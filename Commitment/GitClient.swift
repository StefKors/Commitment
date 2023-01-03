//
//  GitClient.swift
//  Commitment
//
//  Created by Stef Kors on 06/04/2022.
//

import Foundation

class GitClient: ObservableObject {
    var workspace: String

    init(workspace: String) {
        self.workspace = workspace
    }

    func branch() -> String {
        Shell.run("git rev-parse --abbrev-ref HEAD", in: workspace)
    }

    func commitHistory(entries: Int?) -> [Commit] {
        var entriesString = ""
        if let entries = entries { entriesString = "-n \(entries)" }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        return Shell.run("git log --pretty=%h¦%s¦%aN¦%aD¦ \(entriesString)", in: workspace)
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

    func add() {
        Shell.run("git add .", in: workspace)
            .split(separator: "\n")
            .forEach { line in
                print(line)
            }
    }

    func commit(message: String) {
        self.add()

        Shell.run("git commit -m \"\(message)\"", in: workspace)
            .split(separator: "\n")
            .forEach { line in
                print(line)
            }
    }
}

extension GitClient {
    struct Commit: Equatable {
        let hash: String
        let message: String
        let author: String
        let date: Date
    }
}

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
