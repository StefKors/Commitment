//
//  CommitHistoryDetailView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI


struct CommitHistoryDetailView: View {
    var fileStatus: GitFileStatus?
    var diff: GitDiff?

    var body: some View {
        if let diff, let fileStatus {
            FileDiffChangesView(fileStatus: fileStatus, diff: diff)
        } else {
            Text("place holder file diff")
        }
    }
}
