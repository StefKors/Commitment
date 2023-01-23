//
//  GitFileStatusView.swift
//  Commitment
//
//  Created by Stef Kors on 12/01/2023.
//

import SwiftUI


struct GitFileStatusView: View {
    internal init(fileStatus: GitFileStatus) {
        self.fileStatus = fileStatus
        self.labels = fileStatus.path.split(separator: " -> ").compactMap({ URL(filePath: String($0)) })
    }
    
    var fileStatus: GitFileStatus
    let labels: [URL]
    
    var body: some View {
        HStack(alignment: .center) {
            HStack(spacing: .zero, content: {
                ForEach(labels, id: \.self) { label in
                    Text(label.deletingLastPathComponent().path().removingPercentEncoding ?? "")
                        .truncationMode(.tail)
                        .foregroundColor(.secondary)
                    
                    Text(label.lastPathComponent.removingPercentEncoding ?? "")
                        .fixedSize()
                    
                    if labels.count > 1, label == labels.first {
                        Image(systemName: "arrow.right.square")
                            .padding(.horizontal, 8)
                            .foregroundColor(.blue)
                    }
                }
            })
            .lineLimit(1)
            .allowsHitTesting(true)
            
            Spacer()
            FileChangeIconView(type: fileStatus.state.index)
        }
    }
}
