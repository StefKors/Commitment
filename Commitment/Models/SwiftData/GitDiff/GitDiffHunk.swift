//
//  GitDiffHunk.swift
//  GitDiff
//
//  Created by Guillermo Muntaner Perelló on 03/10/2018.
//

import Foundation
import SwiftData
// custom context indicator =

@Model final class GitDiffHunk {
//    static func == (lhs: GitDiffHunk, rhs: GitDiffHunk) -> Bool {
//        return lhs.oldLineStart == rhs.oldLineStart &&
//        lhs.oldLineSpan == rhs.oldLineSpan &&
//        lhs.newLineStart == rhs.newLineStart &&
//        lhs.newLineSpan == rhs.newLineSpan &&
//        lhs.lines == rhs.lines
//    }

//    @Attribute(.unique) var id: String

    var oldLineStart: Int = 0

    var oldLineSpan: Int = 0

    var newLineStart: Int = 0

    var newLineSpan: Int = 0

    @Relationship(deleteRule: .cascade, inverse: \GitDiffHunkLine.hunk)
    var lines = [GitDiffHunkLine]()

    var diff: GitDiff?

    var header: String = ""

//    var description: String {
//        self.header
////        lines.reduce(into: self.header) {
////            $0 += "\n\($1.description)"
////        }
//    }

    init(
        oldLineStart: Int,
        oldLineSpan: Int,
        newLineStart: Int,
        newLineSpan: Int,
        header: String?,
        lines: [GitDiffHunkLine] = []
    ) {
        self.header = header ?? "@@ -\(oldLineStart),\(oldLineSpan) +\(newLineStart),\(newLineSpan) @@"
//        self.id = header ?? "@@ -\(oldLineStart),\(oldLineSpan) +\(newLineStart),\(newLineSpan) @@"
        self.oldLineStart = oldLineStart
        self.oldLineSpan = oldLineSpan
        self.newLineStart = newLineStart
        self.newLineSpan = newLineSpan
        self.lines = lines
    }

//    func copy(
//        oldLineStart: Int? = nil,
//        oldLineSpan: Int? = nil,
//        newLineStart: Int? = nil,
//        newLineSpan: Int? = nil,
//        header: String? = nil,
//        lines: [GitDiffHunkLine]? = nil) -> GitDiffHunk {
//            return GitDiffHunk(
//                oldLineStart: oldLineStart ?? self.oldLineStart,
//                oldLineSpan: oldLineSpan ?? self.oldLineSpan,
//                newLineStart: newLineStart ?? self.newLineStart,
//                newLineSpan: newLineSpan ?? self.newLineSpan,
//                header: header ?? self.header,
//                lines: lines ?? self.lines
//            )
//        }
//
//    func copyAppendingLine(_ line: GitDiffHunkLine) -> GitDiffHunk {
//        var newLines = lines
//        newLines.append(line)
//        return copy(lines: newLines)
//    }

}

extension GitDiffHunk {
    struct Preview {
        static var dataWithCustomContextIndicator: GitDiffHunk {
            return GitDiff(unifiedDiff: GitDiff.Preview.dataWithCustomContextIndicator, modelContext: .previews).hunks.first!
        }
        
        static var versionBump: GitDiffHunk {
            return GitDiff(unifiedDiff: GitDiff.Preview.versionBump, modelContext: .previews).hunks.first!
        }

        static var addedFile: GitDiffHunk {
            return GitDiff(unifiedDiff: GitDiff.Preview.addedFile, modelContext: .previews).hunks.first!
        }

        static var configChanges: GitDiffHunk {
            return GitDiff(unifiedDiff: GitDiff.Preview.configChanges, modelContext: .previews).hunks.first!
        }

        static var deletedFile: GitDiffHunk {
            return GitDiff(unifiedDiff: GitDiff.Preview.deletedFile, modelContext: .previews).hunks.first!
        }

        static var sideBySideSample: GitDiffHunk {
            return GitDiff(unifiedDiff: GitDiff.Preview.sideBySideSample, modelContext: .previews).hunks.first!
        }
    }
}
