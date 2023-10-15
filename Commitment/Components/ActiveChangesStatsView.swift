//
//  ActiveChangesStatsView.swift
//  Commitment
//
//  Created by Stef Kors on 03/05/2023.
//

import SwiftUI

struct ActiveChangesStatsView: View {
    var showBlocks: Bool = false
    @EnvironmentObject private var repo: CodeRepository
    @EnvironmentObject private var shell: Shell
    @State private var stats: GitCommitStats?
    var body: some View {
        VStack {
            if let stats, stats.filesChanged > 0 {
                HStack(spacing: 8) {
                    // Text("^[\(Int(stats.filesChanged)) file](inflect: true) changed")
                    Text("\(Int(stats.filesChanged)) files changed")
                        .foregroundStyle(.secondary)

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
            print("todo: fetch active changes stats")
        }
//        .task(id: repo.status) {
//            self.stats = try? await shell.stats()
//        }
        // TODO: shell activity date
//        .onChange(of: lastUpdate) { _ in
//            Task {
//                self.stats = try? await shell.stats()
//            }
//        }
    }
}

struct ActiveChangesStatsView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveChangesStatsView()
    }
}
