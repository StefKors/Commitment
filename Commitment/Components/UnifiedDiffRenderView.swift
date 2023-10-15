//
//  DiffRenderView.swift
//  Commitment
//
//  Created by Stef Kors on 04/01/2023.
//

import SwiftUI

struct UnifiedDiffRenderView: View {
    var fileStatus: GitFileStatus
    var diff: GitDiff
    
    var body: some View {
        FileView(fileStatus: fileStatus) {
            ForEach(diff.hunks, id: \.id) { hunk in
                DiffHunkView(hunk: hunk)
            }
        }
    }
}

#Preview {
    UnifiedDiffRenderView(fileStatus: .previewVersionBump, diff: .previewVersionBump)
}
