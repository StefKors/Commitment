//
//  FileDiffChangesView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI


struct FileDiffChangesView: View {
    let fileStatus: GitFileStatus
    let diff: GitDiff?

    @AppStorage(Settings.Diff.Mode) private var diffViewMode: DiffViewMode = .unified

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(.vertical) {
                if let diff {
                    switch diffViewMode {
                    case .unified:
                        UnifiedDiffRenderView(fileStatus: fileStatus, diff: diff)
                            .padding()
                    case .sideBySide:
                        SideBySideDiffRenderView(fileStatus: fileStatus, diff: diff)
                            .padding()
                    }
                } else {
                    FileRenderView(fileStatus: fileStatus)
                        .padding()
                }
            }

            FileStatsView(stats: fileStatus.stats)
                .padding()
        }
    }
}

#Preview {
    FileDiffChangesView(fileStatus: .previewVersionBump, diff: .previewVersionBump)
}
