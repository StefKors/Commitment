//
//  CommitHistoryView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI

struct CommitHistoryView: View {
    @EnvironmentObject private var repo: RepoState
    var body: some View {
        CommitHistorySidebarView()
            .frame(minWidth: 300)
            .toolbar(content: {
                // TODO: Hide when sidebar is closed
                ToolbarItem(placement: .automatic) {
                    SplitModeToggleView()
                }

                // TODO: Hide when sidebar is closed
                ToolbarItem(placement: .automatic) {
                    AddRepoView()
                }
            })
        CommitHistoryMainView(id: repo.view.activeCommitSelection)
            .frame(minWidth: 300)
    }
}
