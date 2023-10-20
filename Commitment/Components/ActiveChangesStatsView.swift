//
//  ActiveChangesStatsView.swift
//  Commitment
//
//  Created by Stef Kors on 03/05/2023.
//

import SwiftUI

struct ActiveChangesStatsView: View {
    @AppStorage(Settings.Diff.ShowStatsBlocks) private var showStatsBlocks: Bool = true
    @EnvironmentObject private var repository: CodeRepository

    var body: some View {
        VStack {
            if repository.stats.hasChanges {
                HStack(spacing: 8) {
                    // Text("^[\(Int(stats.filesChanged)) file](inflect: true) changed")
                    Text("\(Int(repository.stats.filesChanged)) files changed")
                        .foregroundStyle(.secondary)

                    HStack(spacing: 2) {
                        Text("+\(repository.stats.insertions)")
                            .foregroundStyle(Color("GitHubDiffGreenBright"))
                        Text("-\(repository.stats.deletions)")
                            .foregroundStyle(Color("GitHubDiffRedBright"))
                    }

                    if showStatsBlocks {
                        CommitStatsBlocksView(blocks: repository.stats.blocks)
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
