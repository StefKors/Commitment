//
//  PendingCommitSummaryItemView.swift
//  Commitment
//
//  Created by Stef Kors on 17/04/2023.
//

import SwiftUI
import TaskTrigger

struct PendingCommitSummaryItemView: View {
    let commit: Commit

    @EnvironmentObject private var shell: Shell
    @State private var stats: ActiveChangesStats?
    @State private var hashUpdate = PlainTaskTrigger()

    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                SidebarCommitLabelView(commit: commit)
                InlineCommitStatsView(stats: stats)
            }
            .padding(4)
        }
        .background(.bar)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .shadow(color: .black.opacity(0.1), radius: 4,  y: 2)
        .border(Color.disabledControlTextColor, width: 1, cornerRadius: 4)
        .task(id: commit.hash, priority: .medium) {
            hashUpdate.trigger()
        }
        .task($hashUpdate) {
            stats = await shell.stats(for: commit.hash)
        }
    }
}

fileprivate struct InlineCommitStatsView: View {
    let stats: ActiveChangesStats?

    var body: some View {
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
}

#Preview {
    InlineCommitStatsView(stats: .previewLargeChanges)
}
