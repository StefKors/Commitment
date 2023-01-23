//
//  FileDiffChangesView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI


struct FileDiffChangesView: View {
    var fileStatus: GitFileStatus
    var diff: GitDiff?

    var body: some View {
        ScrollView(.vertical) {
            if let diff {
                DiffRenderView(fileStatus: fileStatus, diff: diff)
                    .scenePadding()
            } else {
                FileRenderView(fileStatus: fileStatus)
                    .scenePadding()
            }
        }

    }
}
//
// struct FileDiffChangesView_Previews: PreviewProvider {
//     static var previews: some View {
//         FileDiffChangesView()
//     }
// }
