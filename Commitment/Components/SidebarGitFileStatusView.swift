//
//  SidebarGitFileStatusView.swift
//  Commitment
//
//  Created by Stef Kors on 12/01/2023.
//

import SwiftUI

struct SidebarGitFileStatusView: View {
    @AppStorage(Settings.Changes.ShowFullPathInActiveChanges) private var showFullPathInActiveChanges: Bool = true

    internal init(fileStatus: GitFileStatus) {
        self.fileStatus = fileStatus
        // slow here?
        // handles renamed
        self.labels = fileStatus.path.split(separator: " -> ").compactMap({ URL(filePath: String($0)) })
    }
    
    var fileStatus: GitFileStatus
    let labels: [URL]

    var body: some View {
        HStack(alignment: .center) {
            HStack(alignment: .center, spacing: .zero, content: {
                ForEach(labels, id: \.self) { label in
                    let isRename = labels.count > 1
                    GitFileStatusLabelView(label: label, isRename: isRename, showPath: showFullPathInActiveChanges)

                    /// Show arrow right icon for moved files
                    if isRename, label == labels.first {
                        Image(systemName: "arrow.right.square")
                            .padding(.horizontal, 4)
                            .foregroundColor(.blue)
                    }
                }
            })
            .lineLimit(1)
            .allowsHitTesting(true)
            
            Spacer()

            FileStateIconsView(state: fileStatus.state)
        }
    }
}
