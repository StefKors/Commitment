//
//  GitDiffHunkLine.swift
//  GitDiff
//
//  Created by Guillermo Muntaner Perelló on 03/10/2018.
//

import Foundation

/// A diff line inside a hunk,
public struct GitDiffHunkLine {
    
    public let type: GitDiffHunkLineType
    
    public let text: String
    
    internal var description: String {
        switch type {
        case .addition: return "+\(text)"
        case .deletion: return "-\(text)"
        case .unchanged: return " \(text)"
        }
    }
    
    internal init(type: GitDiffHunkLineType, text: String) {
        self.type = type
        self.text = text
    }
}
