//
//  GitDiffLine.swift
//  Commitment
//
//  Created by Stef Kors on 12/01/2023.
//

import Foundation

struct GitDiffLine: CustomDebugStringConvertible {
    let text: String
    let type: LineType
    let originalLineNumber: Int?
    let oldLineNumber: Int?
    let newLineNumber: Int?
    let noTrailingNewLine: Bool = false

    var isIncludeableLine: Bool {
        self.type == .Add || self.type == .Delete
    }

    var content: String {
        String(self.text.prefix(1))
    }

    enum LineType: String {
        case Add = "+"
        case Delete = "-"
        case Context = " "

        /// When comparing two files, diff finds sequences of lines common to both files, interspersed with groups of differing lines called hunks.
        /// https://www.gnu.org/software/diffutils/manual/html_node/Hunks.html
        // case Hunk = ""
    }

    var debugDescription: String {
        return "GitDiffLine(\(text))"
    }
}
