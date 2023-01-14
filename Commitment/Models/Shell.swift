//
//  self.swift
//  Commitment
//
//  Created by Stef Kors on 06/04/2022.
//

import Foundation

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

    func SHAbefore(SHA: String) -> String {
        self.run("git rev-parse \(SHA)~1", in: workspace)
    }

    func status() {
        
    }
}

extension String {
    var lines: [String.SubSequence] {
        self.split(separator: "\n")
    }
}
