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

        HStack {
            HStack(spacing: .zero, content: {
                Text(url.deletingLastPathComponent().path())
                    .truncationMode(.tail)
                    .foregroundColor(.secondary)

                Text(url.lastPathComponent)
            }).lineLimit(1)

            Spacer()
            FileChangeIconView(type: status.state.index)
        }
        .padding(.horizontal)
    }
}

// struct GitFileStatusView_Previews: PreviewProvider {
//     static let status = GitFileStatusList(files: [GitFileStatus(path: "package.json", state: " M")])
//     static var previews: some View {
//         GitFileStatusView()
//     }
// }
