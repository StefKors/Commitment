//
//  ActiveChangesStatsView.swift
//  Commitment
//
//  Created by Stef Kors on 03/05/2023.
//

import SwiftUI

struct ActiveChangesStatsView: View {
    @EnvironmentObject private var repo: RepoState
    @State private var stats: GitCommitStats?
    var body: some View {
        VStack {
            if let stats, stats.filesChanged > 0 {
                HStack(spacing: 8) {
                    Text("^[\(Int(stats.filesChanged)) file](inflect: true) changed")
                        .foregroundStyle(.secondary)

                    HStack(spacing: 2) {
                        Text("+\(stats.insertions)")
                            .foregroundStyle(Color("GitHubDiffGreenBright"))
                        Text("-\(stats.deletions)")
                            .foregroundStyle(Color("GitHubDiffRedBright"))
                    }

                    HStack(spacing: 2) {
                        ForEach(Array(zip(stats.blocks.indices, stats.blocks)), id: \.0) { (index, block) in
                            let size: CGFloat = 10
                            switch block {
                            case .addition:
                                RoundedRectangle(cornerRadius: 2, style: .continuous)
                                    .fill(Color("GitHubDiffGreenBright"))
                                    .frame(width: size, height: size)
                            case .deletion:
                                RoundedRectangle(cornerRadius: 2, style: .continuous)
                                    .fill(Color("GitHubDiffRedBright"))
                                    .frame(width: size, height: size)
                            }
                        }
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

struct ActiveChangesStatsView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveChangesStatsView()
    }
}
