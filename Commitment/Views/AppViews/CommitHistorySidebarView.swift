//
//  CommitHistorySidebarView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI


struct CommitHistorySidebarView: View {
    @EnvironmentObject private var repo: RepoState

    @State private var activeCommitSelection: Commit.ID? = nil

    var body: some View {
        List(selection: $activeCommitSelection) {
            ForEach(repo.commits) { commit in
                NavigationLink(destination: {
                    CommitHistoryMainView(commitId: activeCommitSelection)
                }, label: {
                    SidebarCommitLabelView(commit: commit)
                })
            }
        }.listStyle(SidebarListStyle())
    }
}
