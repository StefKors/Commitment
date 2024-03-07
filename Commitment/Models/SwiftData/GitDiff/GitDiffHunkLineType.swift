//
//  GitDiffHunkLineType.swift
//  GitDiff
//
//  Created by Guillermo Muntaner Perelló on 03/10/2018.
//

import Foundation

/// Types of lines inside a hunk.
enum GitDiffHunkLineType: String, CaseIterable, Codable {
    case context = "context"
    case addition = "addition"
    case deletion = "deletion"
}
