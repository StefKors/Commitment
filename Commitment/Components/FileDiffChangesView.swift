//
//  FileDiffChangesView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI


struct FileDiffChangesView: View {
    let fileStatus: GitFileStatus

    @AppStorage(Settings.Diff.Mode) private var diffViewMode: DiffViewMode = .unified

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.vertical) {
                if let diff = fileStatus.diff {
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
            .contentMargins(.top, 60, for: .scrollContent)
        }
        .task(id: fileStatus) {
            print("hasdiff \((fileStatus.diff != nil).description)")
        }
    }
}

#Preview {
    FileDiffChangesView(fileStatus: .previewVersionBump)
}
