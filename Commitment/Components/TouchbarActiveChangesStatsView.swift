//
//  TouchbarActiveChangesStatsView.swift
//  Commitment
//
//  Created by Stef Kors on 03/05/2023.
//

import SwiftUI

struct TouchbarActiveChangesStatsView: View {
    @AppStorage(Settings.Diff.ShowStatsBlocks) private var showStatsBlocks: Bool = true
    @Environment(CodeRepository.self) private var repository

    var body: some View {
        if repository.stats.hasChanges {
            Image(systemName: "chevron.compact.right")
        }

        if repository.stats.hasChanges {
            HStack(spacing: 8) {
                // Label("^[\(Int(stats.filesChanged)) file](inflect: true) changed", image: "file-diff")
                Label("\(Int(repository.stats.filesChanged)) files changed", image: "file-diff")

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

struct TouchbarActiveChangesStatsView_Previews: PreviewProvider {
    static var previews: some View {
        TouchbarActiveChangesStatsView()
    }
}
