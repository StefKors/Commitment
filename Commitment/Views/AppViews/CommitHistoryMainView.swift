//
//  CommitHistoryMainView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI
import Git

struct CommitHistoryMainView: View {
    @EnvironmentObject private var repo: RepoState
    var commitId: GitLogRecord.ID? = nil

    @State private var activeCommitFileSelection: GitFileStatus.ID? = nil

    var body: some View {
        List(selection: $activeCommitFileSelection) {
            ForEach(repo.status) { file in
                NavigationLink(destination: {
                    // TODO: get actual git file changes
                    CommitHistoryDetailView(fileId: activeCommitFileSelection)
                }, label: {
                    GitFileStatusView(status: file)
                })
            }
        }.listStyle(SidebarListStyle())
    }
}