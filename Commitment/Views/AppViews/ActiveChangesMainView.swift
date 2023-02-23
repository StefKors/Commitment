//
//  ActiveChangesMainView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI

struct ActiveChangesMainView: View {
    @EnvironmentObject private var repo: RepoState
    let fileStatus: GitFileStatus?
    let diffs: [GitDiff] = []
    @State private var diff: GitDiff?

    var body: some View {
        VStack(spacing: 0) {
            ToolbarContentView()
                .zIndex(999)

            Divider()

            ZStack {
                Rectangle().fill(.clear)

                if let fileStatus, !repo.diffs.isEmpty {
                    FileDiffChangesView(fileStatus: fileStatus, diff: diff)
                } else {
                    EmptyView()
                }
            }
        }.task(priority: .userInitiated, {
            if let fileStatus {
                self.diff = repo.diffs.fileStatus(for: fileStatus.id)
            }
        })
    }
}

