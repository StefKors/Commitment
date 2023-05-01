//
//  PendingCommitSummaryItemView.swift
//  Commitment
//
//  Created by Stef Kors on 17/04/2023.
//

import SwiftUI

struct PendingCommitSummaryItemView: View {
    @EnvironmentObject private var repo: RepoState
    let commit: Commit
    @State var line: String?
    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                // Text(commit.subject)
                SidebarCommitLabelView(commit: commit)
                if let line {
                    HStack {
                        Image("file-diff")
                        Text(line)
                        Spacer()
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(.linear)
                }
            }
            .padding(4)
        }
        .task(id: commit.hash, priority: .medium) {
            do {
                let result = try await repo.shell.stats(for: commit.hash)
                line = result
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// struct PendingCommitSummaryItemView_Previews: PreviewProvider {
//     static var previews: some View {
//         PendingCommitSummaryItemView()
//     }
// }
