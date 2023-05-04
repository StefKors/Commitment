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
                        .contextMenu {
                            Button {
                                Task {
                                    await repo.discardActiveChange(path: fileStatus.path)
                                }
                            } label: {
                                Text("Discard Changes")
                            }
                            .keyboardShortcut(.delete)
                        }
                        .tag(fileStatus.id)
                }
            }
            .listStyle(SidebarListStyle())
            .onDeleteCommand {
                Task {
                    await repo.discardActiveChange()
                }
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






