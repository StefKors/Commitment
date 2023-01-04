//
//  GitDiffHunk.swift
//  GitDiff
//
//  Created by Guillermo Muntaner Perelló on 03/10/2018.
//

import Foundation

public struct GitDiffHunk: CustomDebugStringConvertible {
    
    public let oldLineStart: Int
    
    public let oldLineSpan: Int
    
    public let newLineStart: Int
    
    public let newLineSpan: Int
    
    public let lines: [GitDiffHunkLine]
    
    internal var description: String {
        let header = "@@ -\(oldLineStart),\(oldLineSpan) +\(newLineStart),\(newLineSpan) @@"
        return lines.reduce(into: header) {
            $0 += "\n\($1.description)"
        }
    }

    public var debugDescription: String {
        return self.description
    }
    
    internal init(
        oldLineStart: Int,
        oldLineSpan: Int,
        newLineStart: Int,
        newLineSpan: Int,
        lines: [GitDiffHunkLine]
        ) {
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
        lines: [GitDiffHunkLine]? = nil) -> GitDiffHunk {
        
        return GitDiffHunk(
            oldLineStart: oldLineStart ?? self.oldLineStart,
            oldLineSpan: oldLineSpan ?? self.oldLineSpan,
            newLineStart: newLineStart ?? self.newLineStart,
            newLineSpan: newLineSpan ?? self.newLineSpan,
            lines: lines ?? self.lines)
    }
    
    internal func copyAppendingLine(_ line: GitDiffHunkLine) -> GitDiffHunk {
        var newLines = lines
        newLines.append(line)
        return copy(lines: newLines)
    }
    
}
