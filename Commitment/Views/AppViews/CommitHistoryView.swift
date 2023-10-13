//
//  CommitHistoryView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI

struct CommitHistoryView: View {
    @EnvironmentObject private var viewState: ViewState
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
        CommitHistoryMainView(id: viewState.activeCommitSelection)
            .ignoresSafeArea(.all, edges: .top)
            .frame(minWidth: 600)
    }
}
