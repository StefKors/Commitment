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
                    CommitHistoryDetailView(diffs: diffs, fileStatus: fileStatus)
                }, label: {
                    GitFileStatusView(fileStatus: fileStatus)
                })
            }
        }
        .listStyle(SidebarListStyle())
        .task {
            if let commitId {
                // TODO: is this the right way to do paralell?
                Task {
                    if let diffs = try? await repo.shell.diff(at: commitId) {
                        self.diffs = diffs
                    }
                }
                Task {
                    if let files = try? await repo.shell.show(at: commitId) {
                        self.files = files
                    }
                }
            }
        }
    }
}
