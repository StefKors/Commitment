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

struct ActiveChangesStats: Codable {
    init() {
        self.raw = ""
        self.hasChanges = false
        self.blocks = []
        self.filesChanged = 0
        self.insertions = 0
        self.deletions = 0
    }

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

        let total: Int = self.insertions + self.deletions
        let adds: Int = self.insertions.getScaledValue(
            sourceRangeMin: 0,
            sourceRangeMax: total,
            targetRangeMin: 0,
            targetRangeMax: 5
        )

        let dels: Int = self.deletions.getScaledValue(
            sourceRangeMin: 0,
            sourceRangeMax: total,
            targetRangeMin: 0,
            targetRangeMax: 5
        )

        var blockArray: [GitStatBlockType] = []
        for _ in 0..<adds {
            blockArray.append(.addition)
        }

        for _ in 0..<dels {
            blockArray.append(.deletion)
        }

        self.blocks = blockArray

        self.hasChanges = (filesChanged.isNotZero || insertions.isNotZero || deletions.isNotZero)
    }

    var filesChanged: Int = 0
    var insertions: Int = 0
    var deletions: Int = 0
    var hasChanges: Bool = false

    var blocks: [GitStatBlockType]
    let raw: String
}

extension ActiveChangesStats {
    static let preview = ActiveChangesStats("2 files changed, 5 insertions(+), 2 deletions(-)")
    static let previewLargeChanges = ActiveChangesStats("928 files changed, 286 insertions(+), 863 deletions(-)")
    static let previewNoChanges = ActiveChangesStats("")
}

extension Int {
    /// Scale number from a range to a range
    func getScaledValue(
        sourceRangeMin: CGFloat,
        sourceRangeMax: CGFloat,
        targetRangeMin: CGFloat,
        targetRangeMax: CGFloat
    ) -> CGFloat {
        if self == .zero {
            return CGFloat(0)
        }
        let targetRange = targetRangeMax - targetRangeMin;
        let sourceRange = sourceRangeMax - sourceRangeMin;
        return (CGFloat(self) - sourceRangeMin) * targetRange / sourceRange + targetRangeMin;
    }

    /// Scale number from a range to a range
    func getScaledValue(
        sourceRangeMin: Int,
        sourceRangeMax: Int,
        targetRangeMin: Int,
        targetRangeMax: Int
    ) -> Int {
        if self == .zero {
            return 0
        }
        let targetRange = targetRangeMax - targetRangeMin;
        let sourceRange = sourceRangeMax - sourceRangeMin;
        return (self - sourceRangeMin) * targetRange / sourceRange + targetRangeMin;
    }
}
