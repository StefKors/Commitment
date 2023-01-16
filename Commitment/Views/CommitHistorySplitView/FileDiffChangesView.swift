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
            if let fileId, let status = repo.status?.files.first { $0.id == fileId } {
                ScrollView(.vertical) {
                    if let diff = repo.diffs.first { $0.addedFile.contains(String(fileId.split(separator: " -> ").last ?? "")) } {
                        DiffRenderView(status: status, diff: diff)
                    } else {
                        FileRenderView(status: status)
                    }
                }.scenePadding()
            } else {
                ContentPlaceholderView()
            }
    }
}

struct FileDiffChangesView_Previews: PreviewProvider {
    static var previews: some View {
        FileDiffChangesView()
    }
}
