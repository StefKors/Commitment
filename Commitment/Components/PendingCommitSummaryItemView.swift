//
//  PendingCommitSummaryItemView.swift
//  Commitment
//
//  Created by Stef Kors on 17/04/2023.
//

import SwiftUI

enum CommitSummary: Error {
    case emptyString
}

struct PendingCommitSummaryItemView: View {
    @EnvironmentObject private var repo: RepoState
    let commit: Commit
    @State var stats: GitCommitStats?
    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                // Text(commit.subject)
                SidebarCommitLabelView(commit: commit)
                if let stats {
                    HStack {
                        Image("file-diff")
                            .imageScale(.small)
                        Text("\(stats.filesChanged) files changed")
                        Text("\(stats.insertions) +++")
                            .foregroundColor(Color("GitHubDiffGreenBright"))
                        Text("\(stats.deletions) ---")
                            .foregroundColor(Color("GitHubDiffRedBright"))
                        Spacer()
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(.linear)
                }
            }
            .padding(4)
        }
        .task(id: commit.hash, priority: .medium) {
            do {
                stats = try await repo.shell.stats(for: commit.hash)
                let numstat = try await repo.shell.numStat(for: commit.hash)
                print(numstat)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}

// struct PendingCommitSummaryItemView_Previews: PreviewProvider {
//     static var previews: some View {
//         PendingCommitSummaryItemView()
//     }
// }
