//
//  HotKeyActiveChangesSidebarView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI

struct HotKeyActiveChangesSidebarView: View {
    @EnvironmentObject private var repo: RepoState
    @Binding var selection: GitFileStatus.ID?

    var body: some View {
        VStack {
            List(selection: $selection) {
                ForEach(repo.status, id: \.id) { fileStatus in
                    GitFileStatusView(fileStatus: fileStatus)
                        .tag(fileStatus.id)
                        .edgesIgnoringSafeArea(.leading)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .edgesIgnoringSafeArea(.leading)
            Divider()
            TextEditorView(isDisabled: repo.diffs.isEmpty)
                .task {
                    print(repo.status.count.description)
                }
        }
    }
}
