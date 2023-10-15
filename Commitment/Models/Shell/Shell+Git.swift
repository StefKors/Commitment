//
//  Shell+Git.swift
//  Commitment
//
//  Created by Stef Kors on 25/02/2023.
//

import Foundation

enum ShellError: Error {
    case NoGitUser
}


extension Shell {
    func version() async -> String {
        await self.runTask(.git, ["-v"])
    }

    func help() async -> String {
        await self.runTask(.git, ["--help"])
    }

    func listConfig() async -> String {
        await self.runTask(.git, ["config", "--list"])
    }

    func execPath() async -> String {
        await self.runTask(.git, ["--exec-path"])
    }

    func branch() async -> String {
        await self.runTask(.git, ["branch", "--show-current"])
    }

    func add(files: [String]? = nil) async {
        guard let files else {
            // Add everything
            await self.runTask(.git, ["add", "."])
            return
        }

        // Stage provided file paths
        for file in files {
            // Stage file
            await self.runTask(.git, ["add", file])
        }
    }

    func setUser(_ user: GitUser) async {
        await self.runTask(.git, ["config", "user.name", "\(user.name)"])
        await self.runTask(.git, ["config", "user.email", "\(user.email)"])
//        try await getGitUser()
    }

    func getGitUser() async throws -> GitUser {
        let name = await self.runTask(.git, ["config", "user.name"]).trimmingCharacters(in: .whitespacesAndNewlines)
        let email = await self.runTask(.git, ["config", "user.email"]).trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty || email.isEmpty {
            throw ShellError.NoGitUser
        }
        return GitUser(name: name, email: email)
    }

    func commit(title: String, message: String) async {
        await self.add()
        await self.runTask(.git, ["commit", "-m", title, "-m", message])
    }

    func commit(message: String) async throws {
        await self.add()
        await self.runTask(.git, ["commit", "-m", message])
    }

    func push() async throws -> String {
        let remote = await self.remote()
        let branch = await self.branch()
        return await self.runTask(.git, ["push", remote, branch])
    }

    func diff() async -> [GitDiff] {
        let diff = await self.runTask(.git, ["diff"])
        return diff
            .split(separator: "\ndiff --git ")
            .compactMap { diffSegment in
                return GitDiff(unifiedDiff: String(diffSegment))
            }
    }

    func diff(at commitA: String) async -> [GitDiff] {
        let commitB = await self.SHAbefore(SHA: commitA)
        return await self.runTask(.git, ["diff", "\(commitB)..\(commitA)", "--no-ext-diff", "--no-color", "--find-renames"])
            .split(separator: "\ndiff --git ")
            .compactMap { diffSegment in
                return GitDiff(unifiedDiff: String(diffSegment))
            }
    }

    func show(file: String) async -> String {
        let result = await self.runTask(.git, ["show", "--textconv", "HEAD:\(file)"])

        // still handle files not in git history
        if result.starts(with: "fatal: path"), let fileContent = try? String(contentsOf: URL(filePath: file), encoding: .utf8) {
            return fileContent
        }

        return result
    }

    /// Probably not performant
    func show(file: String, defaultType: GitDiffHunkLineType = .unchanged) async -> [GitDiffHunkLine] {
        return await self.show(file: file)
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

    func show(at commit: String) async -> [GitFileStatus] {
        return await self.runTask(.git, ["show", "--oneline", "--name-status", "--no-color", commit])
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
                let stats = await self.numStat(sha: commit, file: fileName)
                return GitFileStatus(path: fileName, state: fileState, sha: commit, stats: stats)
            }.compactMap({$0})
    }

    func SHAbefore(SHA: String) async -> String {
        await self.runTask(.git, ["rev-parse", "\(SHA)~1"])
    }

    func fetch(branch: String) async {
        await self.runTask(.git, ["fetch", "origin", "\(branch):\(branch)"])
    }

    /// Fetches a list of references in this repository
    ///
    /// - Returns: GitReferenceList - a list of references
    /// - Throws: An exception in case any error occured
    func listReferences() async -> [GitReference] {
        // TODO: CHECK if works
        let output = await self.runTask(.git, ["for-each-ref", "--format={$(^QUOTES^)$path$(^QUOTES^)$:$(^QUOTES^)$%(refname)$(^QUOTES^)$,$(^QUOTES^)$id$(^QUOTES^)$:$(^QUOTES^)$%(objectname)$(^QUOTES^)$,$(^QUOTES^)$author$(^QUOTES^)$:$(^QUOTES^)$%(authorname)$(^QUOTES^)$,$(^QUOTES^)$parentId$(^QUOTES^)$:$(^QUOTES^)$%(parent)$(^QUOTES^)$,$(^QUOTES^)$date$(^QUOTES^)$:$(^QUOTES^)$%(creatordate:iso8601-strict)$(^QUOTES^)$,$(^QUOTES^)$message$(^QUOTES^)$:$(^QUOTES^)$%(contents)$(^QUOTES^)$,$(^QUOTES^)$active$(^QUOTES^)$:%(if)%(HEAD)%(then)true%(else)false%(end)}$(END_OF_LINE)$"])

        let decoder = GitFormatDecoder()
        return decoder.decode(output)
    }

    func status() async -> [GitFileStatus] {
        await self.runTask(.git, ["status", "--porcelain"])
            .lines
            .parallelMap { line -> GitFileStatus? in
                guard line.count > 3 else { return nil }
                var trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                let fileState = String(trimmedLine.prefix(2))
                trimmedLine.removeFirst(2)
                var fileName = trimmedLine.trimmingCharacters(in: .whitespaces)
                // When file name contains spaces, need to ensure leading and trailing quoes escapes are removed
                fileName = fileName.trimmingCharacters(in: CharacterSet(charactersIn: "\"\\"))

                let stats = await self.numStat(file: fileName)
                return GitFileStatus(path: fileName, state: fileState, stats: stats)
            }
            .compactMap({$0})
    }

    func log(options: LogOptions = LogOptions.default, isLocal: Bool = false, limit: Int? = nil) async -> [Commit] {
        // Check whether a reference is provided
        if let reference = options.reference, reference.remote == nil {
            // Reference is provided, but it is required to take the first available remote
            let remotes: [Remote]? = await remotes()

            if let remote = remotes?.first {
                options.reference?.firstRemote = remote
            }
        }

        let args = ["--no-pager", "log"]

        var limitArgs: [String] = []
        if let limit {
            limitArgs = ["-n", limit.description]
        }

        let opts: [String] = options.toArguments()
        let format = ["--pretty=$:$%H $:$%h $:$%an $:$%ae $:$%s $:$%B $:$%cI $:$%D$(END_OF_LINE)"]

        return await self.runTask(.git, args + limitArgs + format + opts)
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

    func checkout(_ branch: String) async {
        await self.runTask(.git, ["switch", branch])
    }

    /// run `git remote`
    /// - Returns: all remotes
    func remotes() async -> [String] {
        await self.runTask(.git, ["remote"])
            .lines
            .compactMap({ subStr in
                String(subStr).trimmingCharacters(in: .whitespacesAndNewlines)
            })
    }

    /// run `git remote`
    /// - Returns: all remotes
    func remotes() async -> [Remote]? {
        try? await self.remotes()
            .parallelMap { remote in
                let url: URL = try await self.remoteUrl(for: remote)
                return Remote(name: remote, url: url)
            }
    }

    /// Gets main remote, preferring `origin`, then `upstream` otherwise falling back to the first in the list.
    /// - Returns: first remote or "origin"
    func remote() async -> String {
        // TODO: handle multiple
        let remotes: [String] = await remotes()

        return remotes.sortBy(orderArray: ["origin"]).first ?? "origin"
    }

    func remoteUrl(for name: String) async -> String {
        await self.runTask(.git, ["remote", "get-url", "--all", name])
    }

    func remoteUrl(for name: String) async throws -> URL {
        let result = await self.runTask(.git, ["remote", "get-url", "--all", name])
        if let url = URL(string: result) {
            return url
        } else {
            throw URLError.cantCreateURLFrom(string: result)
        }
    }

    func remoteUrl(for name: String) async -> URL? {
        let result = await self.runTask(.git, ["remote", "get-url", "--all", name])
        return URL(string: result)
    }

    /// Get diff stats of current active changes
    func stats() async -> String {
        return await self.runTask(.git, ["diff", "--shortstat"])
    }

    /// Get diff stats of current active changes
    func stats() async -> GitCommitStats {
        let output = await self.runTask(.git, ["diff", "--shortstat"])
        return GitCommitStats(output)
    }

    /// Get diff stats of a SHA
    func stats(for sha: String) async -> String {
        let shaBefore = await self.SHAbefore(SHA: sha)
        return await self.runTask(.git, ["diff", "--shortstat", shaBefore, sha])
    }

    /// Get diff stats of a SHA
    func stats(for sha: String) async -> GitCommitStats {
        let shaBefore = await self.SHAbefore(SHA: sha)
        let output = await self.runTask(.git, ["diff", "--shortstat", shaBefore, sha])
        return GitCommitStats(output)
    }

    /// Get diff stats of a SHA per file
    func numStat(for sha: String) async -> [GitFileStats] {
        let shaBefore = await self.SHAbefore(SHA: sha)
        let output = await self.runTask(.git, ["diff", "--numstat", shaBefore, sha])
        return output.lines.compactMap { line in
            return GitFileStats(line)
        }
    }

    /// Get diff stats of specific file at a SHA
    func numStat(sha: String, file: String) async -> GitFileStats {
        let shaBefore = await self.SHAbefore(SHA: sha)
        let output = await self.runTask(.git, ["diff", "--numstat", shaBefore, sha, file])
        return GitFileStats(output)
    }

    /// Get diff stats of a specific file not on a commit
    func numStat(file: String) async -> GitFileStats {
        let output = await self.runTask(.git, ["diff", "--numstat", file])
        return GitFileStats(output)
    }

    func undoLastCommit() async {
        await self.runTask(.git, ["reset", "--soft", "HEAD~1"])
    }

    func applyLastStash() async {
        await self.applyStash(0)
    }

    func applyStash(_ number: Int) async {
        await self.runTask(.git, ["stash", "apply", number.description])
    }
}

enum URLError: Error {
    case cantCreateURLFrom(string: String)
}

