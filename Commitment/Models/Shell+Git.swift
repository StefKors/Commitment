//
//  Shell+Git.swift
//  Commitment
//
//  Created by Stef Kors on 25/02/2023.
//

import Foundation

extension Shell {
    func version() async throws -> String {
        try await self.run(.git, "-v")
    }

    func branch() async throws -> String {
        // try await self.run(.git, "rev-parse --abbrev-ref HEAD")
        return try await self.version()
    }

    func commitHistory(entries: Int?) async throws -> [Commit] {
        var entriesString = ""
        if let entries = entries { entriesString = "-n \(entries)" }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        return try await self.run(.git, "log --pretty=%h¦%s¦%aN¦%aD¦ \(entriesString)")
            .split(separator: "\n")
            .map { line -> Commit in
                let parameters = line.components(separatedBy: "¦")
                return Commit(
                    hash: parameters[safe: 0] ?? "",
                    message: parameters[safe: 1] ?? "",
                    author: parameters[safe: 2] ?? "",
                    date: dateFormatter.date(from: parameters[safe: 3] ?? "") ?? Date()
                )
            }
    }

    func add(files: [String]? = nil) async throws {
        guard let files else {
            // Add everything
            try await self.run(.git, "add .")
            return
        }

        // Stage provided file paths
        for file in files {
            // Stage file
            try await self.run(.git, "add \(file)")
        }
    }

    func commit(title: String, message: String) async throws {
        try await self.add()
        try await self.run(.git, "commit -m \"\(title)\" -m \"\(message)\"")
    }

    func commit(message: String) async throws {
        try await self.add()
        try await self.run(.git, "commit -m \"\(message)\"")
    }

    func push() async throws -> String {
        try await self.run(.git, "push")
    }

    func diff() async throws -> [GitDiff] {
        let diff = try await self.run(.git, "diff --no-ext-diff --no-color --find-renames")
        return diff
            .split(separator: "\ndiff --git ")
            .compactMap { diffSegment in
                return try? GitDiff(unifiedDiff: String(diffSegment))
            }
    }

    func diff(at commitA: String) async throws -> [GitDiff] {
        let commitB = try await self.SHAbefore(SHA: commitA)
        return try await self.run(.git, "diff \(commitB)..\(commitA) --no-ext-diff --no-color --find-renames")
            .split(separator: "\ndiff --git ")
            .compactMap { diffSegment in
                return try? GitDiff(unifiedDiff: String(diffSegment))
            }
    }

    func show(file: String) async throws -> String {
        let result = try await self.run(.git, "show --textconv HEAD:\(file)")

        // still handle files not in git history
        if result.starts(with: "fatal: path") {
            return try String(contentsOf: URL(filePath: file), encoding: .utf8)
        }

        return result
    }

    /// Probably not performant
    func show(file: String, defaultType: GitDiffHunkLineType = .unchanged) async throws -> [GitDiffHunkLine] {
        return try await self.show(file: file)
            .split(separator: "\n")
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
        return try await self.run(.git, "show --oneline --name-status --no-color \(commit)")
            .split(separator: "\n")
            .compactMap { line -> GitFileStatus? in
                guard line.count > 3 else { return nil }
                let splits = line.split(separator: "\t")
                // only use the actual file change liens
                guard let first = splits.first,
                      String(first).count == 1 else { return nil }
                let fileState = String(line.prefix(2))
                var fileName = String(line.suffix(from: line.index(line.startIndex, offsetBy: 2)))

                // When file name contains spaces, need to ensure leading and trailing quoes escapes are removed
                fileName = fileName.trimmingCharacters(in: CharacterSet(charactersIn: "\"\\"))

                return GitFileStatus(path: fileName, state: fileState)
            }
    }

    func SHAbefore(SHA: String) async throws -> String {
        try await self.run(.git, "rev-parse \(SHA)~1")
    }

    func fetch(branch: String)async throws {
        try await self.run(.git, "fetch origin \(branch):\(branch)")
    }
}
