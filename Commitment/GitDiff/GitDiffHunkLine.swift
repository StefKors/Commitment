//
//  GitDiffHunkLine.swift
//  GitDiff
//
//  Created by Guillermo Muntaner Perelló on 03/10/2018.
//

import Foundation

/// A diff line inside a hunk,
public struct GitDiffHunkLine: Hashable, Equatable {

    public let type: GitDiffHunkLineType
    
    public let text: String

    public let oldLineNumber: Int?

    public let newLineNumber: Int?
    
    internal var description: String {
        switch type {
        case .addition: return "+\(text)"
        case .deletion: return "-\(text)"
        case .unchanged: return " \(text)"
        }
    }

    internal init(type: GitDiffHunkLineType, text: String, oldLineNumber: Int? = nil, newLineNumber: Int? = nil) {
        self.type = type
        self.text = text
        self.oldLineNumber = oldLineNumber
        self.newLineNumber = newLineNumber
    }
}
