//
//  GitDiffHunkLine.swift
//  GitDiff
//
//  Created by Guillermo Muntaner Perelló on 03/10/2018.
//

import Foundation
import SwiftData
/// A diff line inside a hunk,
///
@Model class GitDiffHunkLine {

//    @Attribute(.unique) var id: String = UUID().uuidString
//    var id: String = UUID().uuidString

    var type: GitDiffHunkLineType

    var text: String

    var oldLineNumber: Int?

    var newLineNumber: Int?

    var hunk: GitDiffHunk?

    init(type: GitDiffHunkLineType, text: String, oldLineNumber: Int? = nil, newLineNumber: Int? = nil) {
        self.type = type
        self.text = text
        self.oldLineNumber = oldLineNumber
        self.newLineNumber = newLineNumber
    }

//    var description: String = ""
//    {
//        switch type {
//        case .addition: return "+\(text)"
//        case .deletion: return "-\(text)"
//        case .context: return " \(text)"
//        }
//    }

//    init(type: GitDiffHunkLineType, text: String, oldLineNumber: Int?, newLineNumber: Int?) {
////        self.type = type
//        self.text = text
//        self.oldLineNumber = oldLineNumber
//        self.newLineNumber = newLineNumber
//    }

//    init(type: GitDiffHunkLineType, text: String, oldLineNumber: Int? = nil, newLineNumber: Int? = nil) {
//        self.type = type
//        self.text = text
//        self.oldLineNumber = oldLineNumber
//        self.newLineNumber = newLineNumber
//
//        self.id = "\(oldLineNumber ?? 0)-\(newLineNumber ?? 0)-\(type)-\(text)"
//    }


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

        static var largeNum: GitDiffHunkLine {
            GitDiffHunkLine(type: .addition, text: "let count = commits.length + 2", oldLineNumber: 12345, newLineNumber: 23456)
        }
    }
}
