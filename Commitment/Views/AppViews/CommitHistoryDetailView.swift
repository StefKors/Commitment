//
//  CommitHistoryDetailView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI


struct CommitHistoryDetailView: View {
    let commitId: Commit.ID?
    let fileStatusId: GitFileStatus.ID?
    let files: [GitFileStatus]
    let diffs: [GitDiff]
    
    @State private var diff: GitDiff?
    @State private var file: GitFileStatus?
    
    var body: some View {
        ZStack {
            Rectangle().fill(.clear)
            
            if let file {
                FileDiffChangesView(fileStatus: file)
                    .tag(file.id)
            } else {
                EmptyView()
            }
        }
        .layoutPriority(1)
        .task(id: commitId, priority: .userInitiated) {
            self.file = files.first(with: fileStatusId)
            self.diff = diffs.fileStatus(for: fileStatusId)
        }
        .task(id: fileStatusId, priority: .userInitiated) {
            self.file = files.first(with: fileStatusId)
            self.diff = diffs.fileStatus(for: fileStatusId)
        }
    }
}
