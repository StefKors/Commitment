//
//  GitCommitStats.swift
//  Commitment
//
//  Created by Stef Kors on 03/05/2023.
//

import Foundation
import RegexBuilder

struct GitCommitStats: Codable {
    // 2 files changed, 5 insertions(+), 2 deletions(-)
    init(_ input: String) {
        self.raw = input

        let separator: Regex<Substring> = /\s{1,}/
        let matcher: Regex = Regex {
            Capture(
                OneOrMore(.digit)
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
                self.filesChanged = Int(String(digit)) ?? 0
            }

            if words.contains("insertion") {
                self.insertions = Int(String(digit)) ?? 0
            }

            if words.contains("deletion") {
                self.deletions = Int(String(digit)) ?? 0
            }
        }
    }

    var filesChanged: Int = 0
    var insertions: Int = 0
    var deletions: Int = 0
    let raw: String
}
