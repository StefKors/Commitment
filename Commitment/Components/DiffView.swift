//
//  DiffView.swift
//  Commitment
//
//  Created by Stef Kors on 04/01/2023.
//

import SwiftUI

struct DiffView: View {
    var diff: GitDiff
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            VStack(alignment: .leading, content: {
                VStack(alignment: .leading, content: {
                    Text(diff.addedFile)
                    Text(diff.removedFile)
                })
                .padding(.top, 7)
                .padding(.horizontal, 10)

                Divider()
            })
            .background(.separator)

            VStack(alignment: .leading, spacing: 0) {
                ForEach(diff.hunks, id: \.description) { hunk in
                    Text(hunk.header)
                    Divider()
                    DiffHunkView(hunk: hunk)
                }
            }
            .fontDesign(.monospaced)
        })
        .background(
            RoundedRectangle(cornerRadius: 6)
                .stroke(.separator, lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct DiffView_Previews: PreviewProvider {
    static var previews: some View {
        DiffView(diff: GitDiff.Preview.toDiff(GitDiff.Preview.versionBump))
            .padding()
    }
}
