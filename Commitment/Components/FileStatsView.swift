//
//  FileStatsView.swift
//  Commitment
//
//  Created by Stef Kors on 03/05/2023.
//

import SwiftUI

struct FileStatsView: View {
    let stats: GitFileStats?

    @AppStorage(Settings.Diff.Mode) private var diffViewMode: DiffViewMode = .unified

    var body: some View {
        if let stats {
            HStack {
                Spacer()
                GroupBox {
                    HStack(spacing: 8) {
                        Text("+\(stats.insertions)")
                            .foregroundColor(Color("GitHubDiffGreenBright"))
                        Divider()
                            .frame(maxHeight: 16)
                        Text("-\(stats.deletions)")
                            .foregroundColor(Color("GitHubDiffRedBright"))
                    }
                }
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .fontDesign(.monospaced)
                .shadow(radius: 4, y: 2)
                .padding()

//                GroupBox {
                    HStack(spacing: 8) {
                        Picker("Choose view style?", selection: $diffViewMode) {
                            Image(systemName: "rectangle.split.2x1.fill").tag(DiffViewMode.sideBySide)
                            Image(systemName: "rectangle.split.1x2.fill").tag(DiffViewMode.unified)
                        }
                        .pickerStyle(.segmented)
                            .labelsHidden()
                            .frame(width: 100)
                    }
//                }
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .fontDesign(.monospaced)
                .shadow(radius: 4, y: 2)
                .padding()
            }
        }
    }
}

struct FileStatsView_Previews: PreviewProvider {
    static var previews: some View {
        FileStatsView(stats: GitFileStats("4    1    Commitment/Views/AppViews/ActiveChangesMainView.swift"))
    }
}
