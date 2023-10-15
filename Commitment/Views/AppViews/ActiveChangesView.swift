//
//  ActiveChangesView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI


struct ActiveChangesView: View {
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

        ActiveChangesMainView()
            .ignoresSafeArea(.all, edges: .top)
            .frame(minWidth: 750, alignment: .leading)
    }
}
