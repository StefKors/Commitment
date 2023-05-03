//
//  Shell+Git.swift
//  Commitment
//
//  Created by Stef Kors on 25/02/2023.
//

import Foundation

extension Shell {
    func version() async throws -> String {
        try await self.runTask(.git, ["-v"])
    }

    func help() async throws -> String {
        try await self.runTask(.git, ["--help"])
    }

    func listConfig() async throws -> String {
        try await self.runTask(.git, ["config", "--list"])
    }

    func execPath() async throws -> String {
        try await self.runTask(.git, ["--exec-path"])
    }

    func branch() async throws -> String {
        try await self.runTask(.git, ["branch", "--show-current"])
    }

    func add(files: [String]? = nil) async throws {
        guard let files else {
            // Add everything
            try await self.runTask(.git, ["add", "."])
            return
        }

        // Stage provided file paths
        for file in files {
            // Stage file
            try await self.runTask(.git, ["add", file])
        }
    }

    func commit(title: String, message: String) async throws {
        try await self.add()
        try await self.runTask(.git, ["commit", "-m", title, "-m", message])
    }

    func commit(message: String) async throws {
        try await self.add()
        try await self.runTask(.git, ["commit", "-m", message])
    }

    func push() async throws -> String {
        let remote = try await self.remote()
        let branch = try await self.branch()
        return try await self.runTask(.git, ["push", remote, branch])
    }

    func diff() async throws -> [GitDiff] {
        let diff = try await self.runTask(.git, ["diff"])
        return diff
            .split(separator: "\ndiff --git ")
            .compactMap { diffSegment in
                return try? GitDiff(unifiedDiff: String(diffSegment))
            }
    }

    func diff(at commitA: String) async throws -> [GitDiff] {
        let commitB = try await self.SHAbefore(SHA: commitA)
        return try await self.runTask(.git, ["diff", "\(commitB)..\(commitA)", "--no-ext-diff", "--no-color", "--find-renames"])
            .split(separator: "\ndiff --git ")
            .compactMap { diffSegment in
                return try? GitDiff(unifiedDiff: String(diffSegment))
            }
    }

    func show(file: String) async throws -> String {
        let result = try await self.runTask(.git, ["show", "--textconv", "HEAD:\(file)"])

        // still handle files not in git history
        if result.starts(with: "fatal: path") {
            return try String(contentsOf: URL(filePath: file), encoding: .utf8)
        }

        return result
    }

    /// Probably not performant
    func show(file: String, defaultType: GitDiffHunkLineType = .unchanged) async throws -> [GitDiffHunkLine] {
        return try await self.show(file: file)
            .lines
            .enumerated()
            .map({ (index, line) in
                return GitDiffHunkLine(
                    type: .unchanged,
                    text: String(line),
                    oldLineNumber: index,
                    newLineNumber: index
                )
            })
    }

    func show(at commit: String) async throws -> [GitFileStatus] {
        return try await self.runTask(.git, ["show", "--oneline", "--name-status", "--no-color", commit])
            .lines
            .parallelMap { line -> GitFileStatus? in
                guard line.count > 3 else { return nil }
                let splits = line.split(separator: "\t")
                // only use the actual file change liens
                guard let first = splits.first,
                      String(first).count == 1 else { return nil }
                let fileState = String(line.prefix(2))
                var fileName = String(line.suffix(from: line.index(line.startIndex, offsetBy: 2)))

                // When file name contains spaces, need to ensure leading and trailing quoes escapes are removed
                fileName = fileName.trimmingCharacters(in: CharacterSet(charactersIn: "\"\\"))
                let stats = try await self.numStat(sha: commit, file: fileName)
                return GitFileStatus(path: fileName, state: fileState, sha: commit, stats: stats)
            }.compactMap({$0})
    }

    func SHAbefore(SHA: String) async throws -> String {
        try await self.runTask(.git, ["rev-parse", "\(SHA)~1"])
    }

    func fetch(branch: String) async throws {
        try await self.runTask(.git, ["fetch", "origin", "\(branch):\(branch)"])
    }

    /// Fetches a list of references in this repository
    ///
    /// - Returns: GitReferenceList - a list of references
    /// - Throws: An exception in case any error occured
    func listReferences() async throws -> [GitReference] {
        // TODO: CHECK if works
        let output = try await self.runTask(.git, ["for-each-ref", "--format={$(^QUOTES^)$path$(^QUOTES^)$:$(^QUOTES^)$%(refname)$(^QUOTES^)$,$(^QUOTES^)$id$(^QUOTES^)$:$(^QUOTES^)$%(objectname)$(^QUOTES^)$,$(^QUOTES^)$author$(^QUOTES^)$:$(^QUOTES^)$%(authorname)$(^QUOTES^)$,$(^QUOTES^)$parentId$(^QUOTES^)$:$(^QUOTES^)$%(parent)$(^QUOTES^)$,$(^QUOTES^)$date$(^QUOTES^)$:$(^QUOTES^)$%(creatordate:iso8601-strict)$(^QUOTES^)$,$(^QUOTES^)$message$(^QUOTES^)$:$(^QUOTES^)$%(contents)$(^QUOTES^)$,$(^QUOTES^)$active$(^QUOTES^)$:%(if)%(HEAD)%(then)true%(else)false%(end)}$(END_OF_LINE)$"])

        let decoder = GitFormatDecoder()
        return decoder.decode(output)
    }

    func status() async throws -> [GitFileStatus] {
        try await self.runTask(.git, ["status", "--porcelain"])
            .lines
            .compactMap { line -> GitFileStatus? in
                guard line.count > 3 else { return nil }
                var trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                let fileState = String(trimmedLine.prefix(2))
                trimmedLine.removeFirst(2)
                var fileName = trimmedLine.trimmingCharacters(in: .whitespaces)
                // When file name contains spaces, need to ensure leading and trailing quoes escapes are removed
                fileName = fileName.trimmingCharacters(in: CharacterSet(charactersIn: "\"\\"))

                return GitFileStatus(path: fileName, state: fileState)
            }
    }

    func log(options: LogOptions = LogOptions.default, isLocal: Bool = false, limit: Int = 100) async throws -> [Commit] {
        // Check whether a reference is provided
        if let reference = options.reference, reference.remote == nil {
            // Reference is provided, but it is required to take the first available remote
            let remotes: [Remote] = try await remotes()

            if let remote = remotes.first {
                options.reference?.firstRemote = remote
            }
        }

        let args = ["--no-pager", "log", "-n", limit.description, "--pretty=$:$%H $:$%h $:$%an $:$%ae $:$%s $:$%B $:$%cI $:$%D$(END_OF_LINE)"]

        let opts: [String] = options.toArguments()

        return try await self.runTask(.git, args + opts)
            .split(separator: "$(END_OF_LINE)")
            .compactMap({ line -> Commit? in
                let parts = line
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .split(separator: "$:$")
                    .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }

                guard let date = try? Date(parts[safe: 6] ?? "", strategy: .iso8601) else { return nil }
                return Commit(
                    hash: parts[safe: 0] ?? "",
                    shortHash: parts[safe: 1] ?? "",
                    authorName: parts[safe: 2] ?? "",
                    authorEmail: parts[safe: 3] ?? "",
                    subject: parts[safe: 4] ?? "",
                    body: parts[safe: 5] ?? "",
                    commiterDate: date,
                    refNames: parts[safe: 7] ?? "",
                    isLocal: isLocal
                )
            })
    }

    func checkout(_ branch: String) async throws {
        try await self.runTask(.git, ["switch", branch])
    }

    /// run `git remote`
    /// - Returns: all remotes
    func remotes() async throws -> [String] {
        try await self.runTask(.git, ["remote"])
            .lines
            .compactMap({ subStr in
                String(subStr).trimmingCharacters(in: .whitespacesAndNewlines)
            })
    }

    /// run `git remote`
    /// - Returns: all remotes
    func remotes() async throws -> [Remote] {
        try await self.remotes()
            .parallelMap { remote in
                let url: URL = try await self.remoteUrl(for: remote)
                return Remote(name: remote, url: url)
            }
    }

    /// Gets main remote, preferring `origin`, then `upstream` otherwise falling back to the first in the list.
    /// - Returns: first remote or "origin"
    func remote() async throws -> String {
        // TODO: handle multiple
        let remotes: [String] = try await remotes()

        return remotes.sortBy(orderArray: ["origin"]).first ?? "origin"
    }

    func remoteUrl(for name: String) async throws -> String {
        try await self.runTask(.git, ["remote", "get-url", "--all", name])
    }

    func remoteUrl(for name: String) async throws -> URL {
        let result = try await self.runTask(.git, ["remote", "get-url", "--all", name])
        if let url = URL(string: result) {
            return url
        } else {
            throw URLError.cantCreateURLFrom(string: result)
        }
    }

    func stats(for sha: String) async throws -> String {
        let shaBefore = try await self.SHAbefore(SHA: sha)
        return try await self.runTask(.git, ["diff", "--shortstat", shaBefore, sha])
    }

    func stats(for sha: String) async throws -> GitCommitStats {
        let shaBefore = try await self.SHAbefore(SHA: sha)
        let output = try await self.runTask(.git, ["diff", "--shortstat", shaBefore, sha])
        return GitCommitStats(output)
    }

    func numStat(for sha: String) async throws -> [GitFileStats] {
        let shaBefore = try await self.SHAbefore(SHA: sha)
        let output = try await self.runTask(.git, ["diff", "--numstat", shaBefore, sha])
        return output.lines.compactMap { line in
            return GitFileStats(line)
        }
    }

    func numStat(sha: String, file: String) async throws -> GitFileStats {
        let shaBefore = try await self.SHAbefore(SHA: sha)
        let output = try await self.runTask(.git, ["diff", "--numstat", shaBefore, sha, file])
        return GitFileStats(output)
    }
}

enum URLError: Error {
    case cantCreateURLFrom(string: String)
}

