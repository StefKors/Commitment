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
        ActiveChangesMainView(fileStatus: nil) // You won't see this in practice (with a default selection)
            .frame(minWidth: 300)
    }
}
