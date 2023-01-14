//
//  FileDiffChangesView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI
import Git

struct FileDiffChangesView: View {
    @EnvironmentObject private var repo: RepoState

    var commitId: GitLogRecord.ID?
    var fileId: GitFileStatus.ID?

    var body: some View {
        ScrollView(.vertical) {
            if let fileId, let status = repo.status?.files.first { $0.id == fileId } {
                if let diff = repo.diffs.first { $0.addedFile.contains(String(fileId.split(separator: " -> ").last ?? "")) } {
                    DiffRenderView(status: status, diff: diff)
                } else {
                    FileRenderView(status: status)
                }
            } else {
                ContentPlaceholderView()
            }
        }.scenePadding()
    }
}

struct FileDiffChangesView_Previews: PreviewProvider {
    static var previews: some View {
        FileDiffChangesView()
    }
}
