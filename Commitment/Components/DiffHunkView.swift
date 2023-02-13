//
//  DiffHunkView.swift
//  Commitment
//
//  Created by Stef Kors on 12/01/2023.
//

import SwiftUI

struct DiffHunkView: View {
    let hunk: GitDiffHunk

    init(hunk: GitDiffHunk) {
        self.hunk = hunk
    }

    var body: some View {
        ForEach(hunk.lines, id: \.id) { line  in
            DiffLineView(line: line)
                .id(line.id)
        }
    }
}

struct DiffHunkView_Previews: PreviewProvider {
    static var previews: some View {
        DiffHunkView(hunk: GitDiffHunk.Preview.versionBump)
    }
}
