//
//  PendingCommitSummaryView.swift
//  Commitment
//
//  Created by Stef Kors on 17/04/2023.
//

import SwiftUI

struct PendingCommitSummaryView: View {
    @EnvironmentObject private var repo: RepoState
    // let SHA: String

    var body: some View {
        VStack {
            HStack {
                Text("Pending Commits")
                    .labelStyle(.titleOnly)
                    .font(.title3)
                    .fontWeight(.semibold)

                Spacer()
                Button("Push commits", action: {
                    Task {
                        // TODO: a way to show progress in toolbar button
                        do {
                            let remote = try await self.repo.shell.remote()
                            let branch = try await self.repo.shell.branch()
                            try? await self.repo.shell.run(.git, ["push", remote, branch], in: self.repo.shell.workspace)
                            try? await self.repo.refreshRepoState()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                })
                .buttonStyle(.borderedProminent)
            }

            ForEach(repo.commitsAhead) { commit in
                PendingCommitSummaryItemView(commit: commit)
                    .id(commit.hash)
            }
        }
        .frame(maxWidth: 400)
        .padding()
   
    }
}
// 
// struct PendingCommitSummaryView_Previews: PreviewProvider {
//     static var previews: some View {
//         // PendingCommitSummaryView()
//     }
// }
