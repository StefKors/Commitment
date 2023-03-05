//
//  CommitHistorySidebarView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI


struct CommitHistorySidebarView: View {
    @EnvironmentObject private var repo: RepoState

    var body: some View {
        List(selection: $repo.view.activeCommitSelection) {
            ForEach(repo.commits) { commit in
                SidebarCommitLabelView(commit: commit)
                    .tag(commit)
            }
        }.listStyle(SidebarListStyle())
    }
}
