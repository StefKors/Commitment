//
//  ActiveChangesMainView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI

struct ActiveChangesMainView: View {
    @EnvironmentObject private var repo: RepoState
    let id: GitFileStatus.ID?
    let diffs: [GitDiff] = []
    @State private var fileStatus: GitFileStatus?
    @State private var diff: GitDiff?
    @State private var isLoading: Bool = true

    var body: some View {
        VStack(spacing: 0) {
            ToolbarContentView()
                .zIndex(999)

            Divider()

            ZStack {
                Rectangle().fill(.clear)
                if let fileStatus {

                    ContentPlaceholderView()
                    // FileDiffChangesView(fileStatus: fileStatus, diff: diff)
                } else if !isLoading && repo.commitsAhead.count > 0 {
                    PendingCommitSummaryView()
                } else if !isLoading {
                    ContentPlaceholderView()
                } else {
                    EmptyView()
                }
            }.layoutPriority(1)
        }
        .task(id: id, priority: .userInitiated, {
            await getDiffs()
            isLoading = false
        })
        .onChange(of: repo.lastUpdate) { _ in
            Task {
                await getDiffs()
            }
        }
    }

    func getDiffs() async {
        guard isLoading == false else { return }
        let status = repo.status.first(with: id)
        self.fileStatus = status
        if status?.state.index.isAny(of: [.added, .deleted]) == true {
            self.diff = nil
        } else if let id {
            self.diff = repo.diffs.fileStatus(for: id)
        }
    }
}

