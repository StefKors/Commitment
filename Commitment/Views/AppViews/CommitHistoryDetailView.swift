//
//  CommitHistoryDetailView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI


struct CommitHistoryDetailView: View {
    let diffs: [GitDiff]
    let fileStatus: GitFileStatus?
    @State private var diff: GitDiff?

    var body: some View {
        Group {
            if let diff, let fileStatus {
                FileDiffChangesView(fileStatus: fileStatus, diff: diff)
            } else {
                EmptyView()
            }
        }.task(priority: .userInitiated, {
            if let fileStatus {
                self.diff = diffs.fileStatus(for: fileStatus.id)
            }
        })
    }
}
