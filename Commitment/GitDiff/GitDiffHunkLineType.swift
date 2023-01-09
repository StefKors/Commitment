//
//  GitDiffHunkLineType.swift
//  GitDiff
//
//  Created by Guillermo Muntaner Perelló on 03/10/2018.
//

import Foundation

/// Types of lines inside a hunk.
public enum GitDiffHunkLineType: String {
    case unchanged
    case addition
    case deletion
}
