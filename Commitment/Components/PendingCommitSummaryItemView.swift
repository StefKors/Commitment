//
//  PendingCommitSummaryItemView.swift
//  Commitment
//
//  Created by Stef Kors on 17/04/2023.
//

import SwiftUI

struct PendingCommitSummaryItemView: View {
    @EnvironmentObject private var repo: RepoState
    let commit: Commit
    @State var line: String = ""
    var body: some View {
        VStack {
            Image("file-diff")
            Text(commit.shortHash)
            Text(line)
        }
        .task(id: commit.hash, priority: .medium) {
            if let result = try? await repo.shell.stats(for: commit.hash) {
                line = result
            }
        }
    }
}

// struct PendingCommitSummaryItemView_Previews: PreviewProvider {
//     static var previews: some View {
//         PendingCommitSummaryItemView()
//     }
// }
