//
//  GitFileStats.swift
//  Commitment
//
//  Created by Stef Kors on 01/05/2023.
//

import Foundation
import RegexBuilder


struct GitFileStats: Codable {
    // 2 files changed, 5 insertions(+), 2 deletions(-)
    init(_ input: String) {
        self.raw = input

        let separator: Regex<Substring> = /\s{1,}/
        let matcher: Regex = Regex {
            Capture(
                One(.digit)
            )
            separator
            Capture(
                OneOrMore(.word)
            )
        }

        let matches = input.matches(of: matcher)
        for match in matches {
            let (_, digit, words) = match.output
            if words.contains("file") {
                self.fileChanged = Int(String(digit)) ?? 0
            }

            if words.contains("insertion") {
                self.insertions = Int(String(digit)) ?? 0
            }

            if words.contains("deletion") {
                self.deletions = Int(String(digit)) ?? 0
            }
        }
    }

    var fileChanged: Int = 0
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
