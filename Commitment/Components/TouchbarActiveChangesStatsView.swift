//
//  TouchbarActiveChangesStatsView.swift
//  Commitment
//
//  Created by Stef Kors on 03/05/2023.
//

import SwiftUI

struct TouchbarActiveChangesStatsView: View {
    var showBlocks: Bool = false
    @EnvironmentObject private var repo: CodeRepository
    @EnvironmentObject private var shell: Shell
    @State private var stats: GitCommitStats?
    var body: some View {
        if let stats, stats.filesChanged > 0 {
            Image(systemName: "chevron.compact.right")
        }

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
        .task {
            print("todo: touchbar stats")
        }
//        .task(id: repo.status) {
//            self.stats = try? await shell.stats()
//        }
        // TODO: check if stats update correctly
//        .onChange(of: repo.lastUpdate) { _ in
//            Task {
//                self.stats = try? await shell.stats()
//            }
//        }
    }
}

struct TouchbarActiveChangesStatsView_Previews: PreviewProvider {
    static var previews: some View {
        TouchbarActiveChangesStatsView()
    }
}
