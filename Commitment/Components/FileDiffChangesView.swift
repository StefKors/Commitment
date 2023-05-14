//
//  FileDiffChangesView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI


struct FileDiffChangesView: View {
    @AppStorage("DiffSettings.ViewMode") private var diffViewMode: DiffViewMode = .unified
    @AppStorage("SideBySideView") private var sideBySide: Bool = false
    let fileStatus: GitFileStatus
    let diff: GitDiff?

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(.vertical) {
                if let diff {
                    switch diffViewMode {
                    case .unified:
                        UnifiedDiffRenderView(fileStatus: fileStatus, diff: diff)
                            .padding()
                    case .sideBySide:
                        if sideBySide {
                            SideBySideDiffRenderView(fileStatus: fileStatus, diff: diff)
                                .padding()
                        } else {
                            UnifiedDiffRenderView(fileStatus: fileStatus, diff: diff)
                                .padding()
                        }
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
//
// struct FileDiffChangesView_Previews: PreviewProvider {
//     static var previews: some View {
//         FileDiffChangesView()
//     }
// }
