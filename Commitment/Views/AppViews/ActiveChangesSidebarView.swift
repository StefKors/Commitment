//
//  ActiveChangesSidebarView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI


struct ActiveChangesSidebarView: View {
    @EnvironmentObject private var repo: RepoState

    var body: some View {
        VStack {
            List(selection: $repo.view.activeChangesSelection) {
                ForEach(repo.status, id: \.id) { fileStatus in
                    GitFileStatusView(fileStatus: fileStatus)
                        .tag(fileStatus.id)
                        .activeChangesContextMenu()
                }
            }
            .listStyle(SidebarListStyle())
            .onDeleteCommand {
                print("todo: discard changes delete command")
            }

            ActiveChangesStatsView()
            Divider()
            VStack {
                TextEditorView(isDisabled: repo.diffs.isEmpty)
                UndoActivityView()
            }
            .padding(.bottom)
        }
    }
}
