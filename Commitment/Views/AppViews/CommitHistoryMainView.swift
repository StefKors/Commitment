//
//  CommitHistoryMainView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI


struct CommitHistoryMainView: View {
    @EnvironmentObject private var repo: RepoState
    var commitId: GitLogRecord.ID? = nil

    @State private var activeCommitFileSelection: GitFileStatus.ID? = nil

    @State private var diffs: [GitDiff] = []
    @State private var files: [GitFileStatus] = []

    var body: some View {
        List(selection: $activeCommitFileSelection) {
            ForEach(files) { fileStatus in
                NavigationLink(destination: {
                    let diff = diffs.fileStatus(for: fileStatus.id)
                    CommitHistoryDetailView(fileStatus: fileStatus, diff: diff)
                }, label: {
                    GitFileStatusView(fileStatus: fileStatus)
                })
            }
        }
        .listStyle(SidebarListStyle())
        .task {
            if let commitId {
                self.diffs = repo.shell.diff(at: commitId)
                self.files = repo.shell.show(at: commitId)
            }
        }
    }
}
