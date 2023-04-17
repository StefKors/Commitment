//
//  Commit.swift
//  Commitment
//
//  Created by Stef Kors on 12/01/2023.
//

import Foundation

struct Commit: Equatable, Codable, Hashable, Identifiable {
    var id: String {
        self.hash
    }

    /// Commit hash
    var hash: String

    /// Abbreviated commit hash
    var shortHash: String

    /// An author name
    var authorName: String

    /// An email of an author
    var authorEmail: String

    /// A commit subject
    var subject: String

    /// A commit body
    var body: String

    /// Committer date, strict ISO 8601 format
    var commiterDate: Date

    /// Reference names
    var refNames: String

    /// Optional boolean if commit is local or not
    var isLocal: Bool? = nil
}

extension Commit {
    // static let sample = Commit
}

extension Collection where Element == Commit {
    func merge(_ second: [Commit]) -> [Commit] {
        var secondCopy = second
        let updatedFirst = self.map({ commit -> Commit in
            let updatedIndex = secondCopy.firstIndex(where: {$0.hash == commit.hash})
            if let updatedIndex = updatedIndex {
                let updated = secondCopy[updatedIndex]
                secondCopy.remove(at: updatedIndex)
                return updated
            } else {
                return commit
            }
        })
        return updatedFirst + secondCopy
    }
}
