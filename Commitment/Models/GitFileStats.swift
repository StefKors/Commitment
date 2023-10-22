//
//  GitFileStats.swift
//  Commitment
//
//  Created by Stef Kors on 01/05/2023.
//

import Foundation
import RegexBuilder


public struct GitFileStats: Codable, Equatable {
    // 4    1    Commitment/Views/AppViews/ActiveChangesMainView.swift
    init(_ input: String) {
        self.raw = input

        let separator: Regex<Substring> = /\s{1,}/
        let anyUntilEndOfLine: Regex<Substring> = /.*/
        let matcher: Regex = Regex {
            Capture(
                OneOrMore(.digit)
            )
            separator
            Capture(
                OneOrMore(.digit)
            )
            separator
            Capture(
                anyUntilEndOfLine
            )
        }

        let matches = input.matches(of: matcher)
        for match in matches {
            let (_, insertions, deletions, file) = match.output

            self.insertions = Int(String(insertions)) ?? 0

            self.deletions = Int(String(deletions)) ?? 0

            self.fileChanged = String(file)
        }
    }

    init(fileChanged: String? = nil, insertions: Int, deletions: Int, raw: String) {
        self.fileChanged = fileChanged
        self.insertions = insertions
        self.deletions = deletions
        self.raw = raw
    }

    var fileChanged: String?
    var insertions: Int = 0
    var deletions: Int = 0
    let raw: String
}

extension String {
    /// Returns the number at start of string. for example: "2 files changed" returns "2"
    /// - Returns: Number or nil
    func firstCharInt() -> Int? {
        if let changed = self.trimmingCharacters(in: .whitespaces).first,
           let value = Int(String(changed)) {
            return value
        }
        return nil
    }
}


extension String.SubSequence {
    /// Returns the number at start of string. for example: "2 files changed" returns "2"
    /// - Returns: Number or nil
    func firstCharInt() -> Int? {
        if let changed = self.trimmingCharacters(in: .whitespaces).first,
           let value = Int(String(changed)) {
            return value
        }
        return nil
    }
}
