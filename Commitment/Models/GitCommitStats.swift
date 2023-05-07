//
//  GitCommitStats.swift
//  Commitment
//
//  Created by Stef Kors on 03/05/2023.
//

import Foundation
import RegexBuilder

enum GitStatBlockType: String, Codable {
    case addition
    case deletion
}

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

        let total = self.insertions + self.deletions
        let adds = Int(self.insertions.getScaledValue(
            sourceRangeMin: 0,
            sourceRangeMax: CGFloat(total),
            targetRangeMin: 0,
            targetRangeMax: 5
        ).rounded())

        let dels = Int(self.deletions.getScaledValue(
            sourceRangeMin: 0,
            sourceRangeMax: CGFloat(total),
            targetRangeMin: 0,
            targetRangeMax: 5
        ).rounded())

        var blockArray: [GitStatBlockType] = []
        for _ in 0..<adds {
            blockArray.append(.addition)
        }

        for _ in 0..<dels {
            blockArray.append(.deletion)
        }

        self.blocks = blockArray
    }

    var filesChanged: Int = 0
    var insertions: Int = 0
    var deletions: Int = 0

    var blocks: [GitStatBlockType]
    let raw: String
}

extension Int {
    /// Scale number from a range to a range
    func getScaledValue(sourceRangeMin: CGFloat, sourceRangeMax: CGFloat, targetRangeMin: CGFloat, targetRangeMax: CGFloat) -> CGFloat {
        if self == .zero {
            return CGFloat(0)
        }
        var targetRange = targetRangeMax - targetRangeMin;
        var sourceRange = sourceRangeMax - sourceRangeMin;
        return (CGFloat(self) - sourceRangeMin) * targetRange / sourceRange + targetRangeMin;
    }
}
