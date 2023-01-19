//
//  ActiveChangesSidebarView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI
import Git

struct ActiveChangesSidebarView: View {
    @EnvironmentObject private var repo: RepoState

    @State private var activeChangesSelection: GitFileStatus.ID? = nil

    var body: some View {
        VStack {
            List(selection: $activeChangesSelection) {
                ForEach(repo.status) { file in
                    NavigationLink(destination: {
                        ActiveChangesMainView(fileId: activeChangesSelection)
                    }, label: {
                        GitFileStatusView(status: file)
                    })
                }
            }.listStyle(SidebarListStyle())
            Divider()
            TextEditorView(isDisabled: repo.diffs.isEmpty)
        }
    }
}
