//
//  ActiveChangesView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI


struct ActiveChangesView: View {
    @EnvironmentObject private var repo: RepoState
    var body: some View {
        ActiveChangesSidebarView()
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

        ActiveChangesMainView(id: repo.view.activeChangesSelection)
            .ignoresSafeArea(.all, edges: .top)
            .frame(minWidth: 300)
    }
}
