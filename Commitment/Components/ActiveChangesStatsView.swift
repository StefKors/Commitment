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
            if let stats {
                HStack(spacing: 8) {
                    Text("^[\(Int(stats.filesChanged)) file](inflect: true) changed")
                        .foregroundColor(.secondary)
                    Text("+\(stats.insertions)")
                        .foregroundColor(Color("GitHubDiffGreenBright"))
                        .frame(maxHeight: 16)
                    Text("-\(stats.deletions)")
                        .foregroundColor(Color("GitHubDiffRedBright"))
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
