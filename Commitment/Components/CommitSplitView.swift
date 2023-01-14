//
//  CommitSplitView.swift
//  Commitment
//
//  Created by Stef Kors on 13/01/2023.
//

import SwiftUI
import Git

struct CommitSplitView: View {
    var commit: GitLogRecord
    var commitId: GitLogRecord.ID?
    @SceneStorage("SplitView.HistorySelectedFileID") private var fileId: GitFileStatus.ID?

    @EnvironmentObject private var repo: RepoState
    var body: some View {
        if let files = repo.status?.files {
            HSplitView {
                List(files, selection: $fileId) { file in
                    GitFileStatusView(status: file)
                }

                ZStack {
                    Rectangle().fill(.background)
                    FileDiffChangesView(commitId: commitId, fileId: fileId)
                }
            }
        }
    }
}

