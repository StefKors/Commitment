//
//  ActiveChangesStatsView.swift
//  Commitment
//
//  Created by Stef Kors on 03/05/2023.
//

import SwiftUI

struct ActiveChangesStatsView: View {
    @AppStorage(Settings.Diff.ShowStatsBlocks) private var showStatsBlocks: Bool = true
    @EnvironmentObject private var activeChangesState: ActiveChangesState

    var body: some View {
        VStack {
            if activeChangesState.stats.hasChanges {
                HStack(spacing: 8) {
                    // Text("^[\(Int(stats.filesChanged)) file](inflect: true) changed")
                    Text("\(Int(activeChangesState.stats.filesChanged)) files changed")
                        .foregroundStyle(.secondary)

                    HStack(spacing: 2) {
                        Text("+\(activeChangesState.stats.insertions)")
                            .foregroundStyle(Color("GitHubDiffGreenBright"))
                        Text("-\(activeChangesState.stats.deletions)")
                            .foregroundStyle(Color("GitHubDiffRedBright"))
                    }

                    if showStatsBlocks {
                        CommitStatsBlocksView(blocks: activeChangesState.stats.blocks)
                    }
                }
            }
        }
    }
}

struct ActiveChangesStatsView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveChangesStatsView()
    }
}
