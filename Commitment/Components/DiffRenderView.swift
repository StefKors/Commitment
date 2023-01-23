//
//  DiffRenderView.swift
//  Commitment
//
//  Created by Stef Kors on 04/01/2023.
//

import SwiftUI

struct DiffRenderView: View {
    var fileStatus: GitFileStatus
    var diff: GitDiff
    
    var body: some View {
        FileView(fileStatus: fileStatus) {
            ForEach(diff.hunks, id: \.description) { hunk in
                DiffHunkView(hunk: hunk)
            }
        }
    }
}

// struct DiffRenderView_Previews: PreviewProvider {
//     static var previews: some View {
//         DiffRenderView(diff: GitDiff.Preview.toDiff(GitDiff.Preview.versionBump))
//             .padding()
//     }
// }
