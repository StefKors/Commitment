//
//  ActiveChangesMainView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI

struct ActiveChangesMainView: View {
    @EnvironmentObject private var repo: CodeRepository
    @EnvironmentObject private var viewState: ViewState
    @EnvironmentObject private var activeChangesState: ActiveChangesState

//    let id: GitFileStatus?


    let diffs: [GitDiff] = []
    @State private var diff: GitDiff?
    @State private var isLoading: Bool = true

    var body: some View {
        VStack(spacing: 0) {
            ToolbarContentView()
                .zIndex(999)

            Divider()

            ZStack {
                Rectangle().fill(.clear)
                if let fileStatus = viewState.activeChangesSelection {
                    FileDiffChangesView(fileStatus: fileStatus, diff: diff)
                } else if !isLoading {
                    ContentPlaceholderView()
                } else {
                    EmptyView()
                }
            }.layoutPriority(1)
        }
        .task(id: viewState.activeChangesSelection) {
            if let fileStatus = viewState.activeChangesSelection {
                self.diff = activeChangesState.diffs[fileStatus.cleanedPath]
            }
            isLoading = false
        }
    }
}

