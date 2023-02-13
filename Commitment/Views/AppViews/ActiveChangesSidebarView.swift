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
                ForEach(repo.status, id: \.id) { fileStatus in
                    NavigationLink(destination: {
                        ActiveChangesMainView(fileStatus: fileStatus)
                            .id(fileStatus.id)
                    }, label: {
                        GitFileStatusView(fileStatus: fileStatus)
                            .id(fileStatus.id)
                    })
                }
            }.listStyle(SidebarListStyle())
            Divider()
            TextEditorView(isDisabled: repo.diffs.isEmpty)
        }
    }
}
