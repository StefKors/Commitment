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
            HStack(spacing: 8) {
                Picker("Choose view style?", selection: $diffViewMode) {
                    Image(systemName: "rectangle.split.2x1.fill").tag(DiffViewMode.sideBySide)
                    Image(systemName: "rectangle.split.1x2.fill").tag(DiffViewMode.unified)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .frame(width: 100)
            }
            Divider()

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
        }
        .task(id: fileStatus) {
            print("hasdiff \((fileStatus.diff != nil).description)")
        }
    }
}

#Preview {
    FileDiffChangesView(fileStatus: .previewVersionBump)
}
