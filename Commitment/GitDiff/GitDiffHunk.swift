//
//  GitDiffHunk.swift
//  GitDiff
//
//  Created by Guillermo Muntaner Perelló on 03/10/2018.
//

import Foundation

public struct GitDiffHunk: Identifiable, Codable, Equatable {
    public static func == (lhs: GitDiffHunk, rhs: GitDiffHunk) -> Bool {
        return lhs.oldLineStart == rhs.oldLineStart &&
        lhs.oldLineSpan == rhs.oldLineSpan &&
        lhs.newLineStart == rhs.newLineStart &&
        lhs.newLineSpan == rhs.newLineSpan &&
        lhs.lines == rhs.lines
    }

    public let id: UUID

    public let oldLineStart: Int
    
    public let oldLineSpan: Int
    
    public let newLineStart: Int
    
    public let newLineSpan: Int
    
    public let lines: [GitDiffHunkLine]

    public let header: String
    
    internal let description: String
    
    internal init(
        oldLineStart: Int,
        oldLineSpan: Int,
        newLineStart: Int,
        newLineSpan: Int,
        header: String?,
        lines: [GitDiffHunkLine]
    ) {
        self.id = UUID()
        self.header = header ?? "@@ -\(oldLineStart),\(oldLineSpan) +\(newLineStart),\(newLineSpan) @@"
        self.description = lines.reduce(into: self.header) {
            $0 += "\n\($1.description)"
        }
        self.oldLineStart = oldLineStart
        self.oldLineSpan = oldLineSpan
        self.newLineStart = newLineStart
        self.newLineSpan = newLineSpan
        self.lines = lines
    }
    
    internal func copy(
        oldLineStart: Int? = nil,
        oldLineSpan: Int? = nil,
        newLineStart: Int? = nil,
        newLineSpan: Int? = nil,
        header: String? = nil,
        lines: [GitDiffHunkLine]? = nil) -> GitDiffHunk {
            return GitDiffHunk(
                oldLineStart: oldLineStart ?? self.oldLineStart,
                oldLineSpan: oldLineSpan ?? self.oldLineSpan,
                newLineStart: newLineStart ?? self.newLineStart,
                newLineSpan: newLineSpan ?? self.newLineSpan,
                header: header ?? self.header,
                lines: lines ?? self.lines
            )
        }
    
    internal func copyAppendingLine(_ line: GitDiffHunkLine) -> GitDiffHunk {
        var newLines = lines
        newLines.append(line)
        return copy(lines: newLines)
    }
    
}

extension GitDiffHunk {
    struct Preview {
        static var versionBump: GitDiffHunk {
            return GitDiff.Preview.toDiff(GitDiff.Preview.versionBump).hunks.first!
        }
    }
}
