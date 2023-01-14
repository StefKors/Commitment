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
    @Binding var fileId: GitFileStatus.ID?

    @EnvironmentObject private var repo: RepoState
    var body: some View {
        if let files = repo.status?.files {
            HSplitView {
                List(files, selection: $fileId) { file in
                    GitFileStatusView(status: file)
                }


                ZStack {
                    Rectangle().fill(.background)
                    ScrollView(.vertical) {
                        if let fileId, let diff = repo.diffs.first { $0.addedFile.contains(fileId) }, let status = repo.status?.files.first { $0.id == fileId } {
                            DiffView(status: status, diff: diff)
                                .scenePadding()
                        }
                    }
                }
            }
        }
    }
}

