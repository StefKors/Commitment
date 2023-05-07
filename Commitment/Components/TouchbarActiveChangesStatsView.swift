//
//  TouchbarActiveChangesStatsView.swift
//  Commitment
//
//  Created by Stef Kors on 03/05/2023.
//

import SwiftUI

struct TouchbarActiveChangesStatsView: View {
    var showBlocks: Bool = false
    @EnvironmentObject private var repo: RepoState
    @State private var stats: GitCommitStats?
    var body: some View {
        VStack {
            if let stats, stats.filesChanged > 0 {
                HStack(spacing: 8) {
                    // Label("^[\(Int(stats.filesChanged)) file](inflect: true) changed", image: "file-diff")
                    Label("\(Int(stats.filesChanged)) files changed", image: "file-diff")

                    HStack(spacing: 2) {
                        Text("+\(stats.insertions)")
                            .foregroundStyle(Color("GitHubDiffGreenBright"))
                        Text("-\(stats.deletions)")
                            .foregroundStyle(Color("GitHubDiffRedBright"))
                    }

                    if showBlocks {
                        CommitStatsBlocksView(blocks: stats.blocks)
                    }
                }
            }
        }
        .task(id: repo.status) {
            self.stats = try? await repo.shell.stats()
        }
        .onChange(of: repo.lastUpdate) { _ in
            Task {
                self.stats = try? await repo.shell.stats()
            }
        }
    }
}

struct TouchbarActiveChangesStatsView_Previews: PreviewProvider {
    static var previews: some View {
        TouchbarActiveChangesStatsView()
    }
}
