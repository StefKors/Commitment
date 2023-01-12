//
//  GitHunkLinkPreviewContent.swift
//  Commitment
//
//  Created by Stef Kors on 12/01/2023.
//

import Foundation

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
