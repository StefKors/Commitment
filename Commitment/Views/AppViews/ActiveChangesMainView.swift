//
//  ActiveChangesMainView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI

struct ActiveChangesMainView: View {
    @EnvironmentObject private var repo: RepoState
    var fileStatus: GitFileStatus?
    var diff: GitDiff?

    var body: some View {
        if let fileStatus, !repo.diffs.isEmpty {
            FileDiffChangesView(fileStatus: fileStatus, diff: diff)
        } else {
            Text("ContentPlaceholderView()")
        }
    }
}
