//
//  GitFileStatusView.swift
//  Commitment
//
//  Created by Stef Kors on 12/01/2023.
//

import SwiftUI
import Git

struct GitFileStatusView: View {
    var status: GitFileStatus
    var body: some View {
        let url = URL(filePath: status.path)

        HStack(alignment: .center) {
            HStack(spacing: .zero, content: {
                Text(url.deletingLastPathComponent().path().removingPercentEncoding ?? "")
                    .truncationMode(.tail)
                    .foregroundColor(.secondary)

                Text(url.lastPathComponent.removingPercentEncoding ?? "")
            }).lineLimit(1)

            Spacer()
            FileChangeIconView(type: status.state.index)
        }
    }
}
