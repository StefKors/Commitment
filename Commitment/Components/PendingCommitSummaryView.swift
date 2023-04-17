//
//  PendingCommitSummaryView.swift
//  Commitment
//
//  Created by Stef Kors on 17/04/2023.
//

import SwiftUI

struct PendingCommitSummaryView: View {
    @EnvironmentObject private var repo: RepoState
    // let SHA: String

    var body: some View {
        VStack {
            ForEach(repo.commitsAhead) { commit in
                PendingCommitSummaryItemView(commit: commit)
            }
        }
        Text("results")
   
    }
}
// 
// struct PendingCommitSummaryView_Previews: PreviewProvider {
//     static var previews: some View {
//         // PendingCommitSummaryView()
//     }
// }
