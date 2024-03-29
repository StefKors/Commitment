//
//  ActiveChangesView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI


struct ActiveChangesView: View {
    @Environment(CodeRepository.self) private var repository

    var body: some View {
        ActiveChangesSidebarView()
            .frame(minWidth: 300)
            .toolbar(content: {
                // TODO: Hide when sidebar is closed
                ToolbarItem(placement: .automatic) {
                    SplitModeToggleView(repository: repository)
                }

                // TODO: Hide when sidebar is closed
                ToolbarItem(placement: .automatic) {
                    AddRepoView()
                }
            })

        ActiveChangesMainView()
            .ignoresSafeArea(.all, edges: .top)
//        750 so nothing clips
//            .frame(minWidth: 750, alignment: .leading)
            .frame(minWidth: 350, alignment: .leading)
    }
}
