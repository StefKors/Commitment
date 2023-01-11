//
//  CommitHistorySplitView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI
import Git

struct CommitHistorySplitView: View {
    var allCommits: [RepositoryLogRecord]

    @SceneStorage("DetailView.selectedTab") private var sidebarSelection: Int = 0

    var body: some View {
        NavigationSplitView {
            List(selection: $sidebarSelection) {
                ForEach(allCommits.indices, id: \.self) { index in
                    NavigationLink(value: index, label: {
                        SidebarCommitLabelView(commit: allCommits[index])
                    })
                }
            }
            .toolbar(content: {
                ToolbarItem {
                    RepoSelectView()
                }

                // TODO: Hide when sidebar is closed
                ToolbarItemGroup(placement: .automatic) {
                    AddRepoView()
                }
            })
        } detail: {
            if let index = sidebarSelection {
                Text("ComitView \(index)")
                CommitView(commit: allCommits[index])
            } else {
                Text("nothing selected")
            }
        }
    }
}
