//
//  ActiveChangesSidebarView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI


struct ActiveChangesSidebarView: View {
    @EnvironmentObject private var repo: RepoState
    @State private var activeChangesSelection: GitFileStatus.ID? = nil

    var body: some View {
        VStack {
            List(selection: $activeChangesSelection) {
                ForEach(repo.status) { fileStatus in
                    NavigationLink(destination: {
                        ActiveChangesMainView(
                            fileStatus: fileStatus,
                            diff: repo.diffs.fileStatus(for: fileStatus.id)
                        )
                    }, label: {
                        GitFileStatusView(fileStatus: fileStatus)
                    })
                }
            }.listStyle(SidebarListStyle())
            Divider()
            TextEditorView(isDisabled: repo.diffs.isEmpty)
        }
        .onChange(of: repo.diffs, perform: { newDiffs in
            if newDiffs.isEmpty {
                activeChangesSelection = nil
            }
        })
    }
}
