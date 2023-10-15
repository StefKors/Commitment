//
//  TouchbarActiveChangesStatsView.swift
//  Commitment
//
//  Created by Stef Kors on 03/05/2023.
//

import SwiftUI

struct TouchbarActiveChangesStatsView: View {
    @AppStorage(Settings.Diff.ShowStatsBlocks) private var showStatsBlocks: Bool = true
    @EnvironmentObject private var activeChangesState: ActiveChangesState

    var body: some View {
        if activeChangesState.stats.hasChanges {
            Image(systemName: "chevron.compact.right")
        }

        if activeChangesState.stats.hasChanges {
            HStack(spacing: 8) {
                // Label("^[\(Int(stats.filesChanged)) file](inflect: true) changed", image: "file-diff")
                Label("\(Int(activeChangesState.stats.filesChanged)) files changed", image: "file-diff")

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

struct TouchbarActiveChangesStatsView_Previews: PreviewProvider {
    static var previews: some View {
        TouchbarActiveChangesStatsView()
    }
}
