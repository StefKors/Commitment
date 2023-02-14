//
//  self.swift
//  Commitment
//
//  Created by Stef Kors on 06/04/2022.
//

import Foundation
import System

public struct ProcessError : Error {
    public var terminationStatus:Int32
    public var output:String
}

class Shell {
    var workspace: String

    init(workspace: String) {
        self.workspace = workspace
    }
    
    func run(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        try? task.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return (String(data: data, encoding: .utf8) ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func run(_ command: String) async throws -> String {
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        return try await withCheckedThrowingContinuation { continuation in
            task.terminationHandler = { process in
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8) ?? ""

                switch process.terminationReason {
                case .uncaughtSignal:
                    let error = ProcessError(terminationStatus: process.terminationStatus, output: output)
                    continuation.resume(throwing:error)
                case .exit:
                    continuation.resume(returning:output)
                @unknown default:
                    //TODO: theoretically, this ought not to happen
                    continuation.resume(returning:output)
                }
            }
            do {
                try task.run()
            } catch {
                continuation.resume(throwing:error)
            }
        }
    }

    @discardableResult
    func run(_ command: String, in folderPath: String) async throws -> String {
        try await self.run("cd \(folderPath);\(command)")
    }

    @discardableResult
    func run(_ command: String, in folderPath: String) -> String {
        self.run("cd \(folderPath);\(command)")
    }

    func branch() -> String {
        self.run("git rev-parse --abbrev-ref HEAD", in: workspace)
    }

    func commitHistory(entries: Int?) -> [Commit] {
        var entriesString = ""
        if let entries = entries { entriesString = "-n \(entries)" }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        return self.run("git log --pretty=%h¦%s¦%aN¦%aD¦ \(entriesString)", in: workspace)
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

    func add(files: [String]? = nil) {
        guard let files else {
            // Add everything
            self.run("git add .", in: workspace)
            return
        }

        // Stage provided file paths
        for file in files {
            // Stage file
            self.run("git add \(file)", in: workspace)
        }

    }

    func commit(message: String) {
        self.add()

        self.run("git commit -m \"\(message)\"", in: workspace)
    }

    func diff() -> [GitDiff] {
        let diffs = self.run("git diff --no-ext-diff --no-color --find-renames", in: workspace)
            .split(separator: "\ndiff --git ")
            .compactMap { diffSegment in
                return try? GitDiff(unifiedDiff: String(diffSegment))
            }


        return diffs
    }

    func diff(at commitA: String) -> [GitDiff] {
        let commitB = self.SHAbefore(SHA: commitA)
        let diffs = self.run("git diff \(commitB)..\(commitA) --no-ext-diff --no-color --find-renames", in: workspace)
            .split(separator: "\ndiff --git ")
            .compactMap { diffSegment in
                return try? GitDiff(unifiedDiff: String(diffSegment))
            }

        return diffs
    }

    func show(at commit: String) -> [GitFileStatus] {
        let result = self.run("git show --oneline --name-status --no-color \(commit)", in: workspace)
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

        return result
    }

    func SHAbefore(SHA: String) -> String {
        self.run("git rev-parse \(SHA)~1", in: workspace)
    }

    func show(file: String) -> String {
        self.run("git show --textconv HEAD:\(file)", in: workspace)
    }

    func show(file: String) async throws -> String {
        try await self.run("git show --textconv HEAD:\(file)", in: workspace)
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

    /// Probably not performant
    func show(file: String, defaultType: GitDiffHunkLineType = .unchanged) -> [GitDiffHunkLine] {
        print("RUNNDING SHOW ON FILE \(file)")
        return self.show(file: file)
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

    func cat(file: String) -> String {
        self.run("cat \(file)", in: workspace)
    }

    /// is it better to open the file via the filesystem?
    func cat(file: String) async throws -> String {
        try await self.run("cat \(file)", in: workspace)
    }

    /// Probably not performant
    func cat(file: String) -> [String] {
        self.cat(file: file)
            .split(separator: "\n")
            .map({ String($0) })
    }
}

extension String {
    var lines: [String.SubSequence] {
        self.split(separator: "\n")
    }
}
