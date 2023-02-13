//
//  GitDiffHunkLine.swift
//  GitDiff
//
//  Created by Guillermo Muntaner Perelló on 03/10/2018.
//

import Foundation

/// A diff line inside a hunk,
public struct GitDiffHunkLine: Identifiable, Codable, Equatable {

    public let id: String

    public let type: GitDiffHunkLineType
    
    public let text: String

    public let oldLineNumber: Int?

    public let newLineNumber: Int?
    
    internal let description: String

    internal init(type: GitDiffHunkLineType, text: String, oldLineNumber: Int? = nil, newLineNumber: Int? = nil) {
        self.type = type
        self.text = text
        self.oldLineNumber = oldLineNumber
        self.newLineNumber = newLineNumber

        self.id = "\(self.oldLineNumber ?? 0)-\(self.newLineNumber ?? 0)-\(self.type)"

        switch type {
        case .addition: self.description = "+\(text)"
        case .deletion: self.description = "-\(text)"
        case .unchanged: self.description = " \(text)"
        }
    }
}

extension GitDiffHunkLine {
    struct Preview {
        static var deletion: GitDiffHunkLine {
            GitDiffHunk.Preview.versionBump.lines[3]
        }

        static var addition: GitDiffHunkLine {
            GitDiffHunk.Preview.versionBump.lines[4]
        }

        static var unchanged: GitDiffHunkLine {
            GitDiffHunk.Preview.versionBump.lines[5]
        }
    }
}
