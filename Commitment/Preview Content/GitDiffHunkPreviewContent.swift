//
//  GitHunkPreviewContent.swift
//  Commitment
//
//  Created by Stef Kors on 12/01/2023.
//

import Foundation

extension GitDiffHunk {
    struct Preview {
        static var versionBump: GitDiffHunk {
            return GitDiff.Preview.toDiff(GitDiff.Preview.versionBump).hunks.first!
        }
    }
}
