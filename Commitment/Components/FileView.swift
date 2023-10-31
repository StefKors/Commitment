//
//  FileView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI


struct FileView<Content: View>: View {
    var fileStatus: GitFileStatus
    @AppStorage(Settings.Changes.ShowFileIconInActiveChanges) private var showFileIconInActiveChanges: Bool = true

    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            VStack(alignment: .leading, content: {
                VStack(alignment: .leading, content: {
                    HStack(alignment: .center) {
                        if showFileIconInActiveChanges {
                            FileTypeIconView(path: fileStatus.path)
                        }

                        GitFileStatusView(fileStatus: fileStatus)
                    }
                })
                .padding(.vertical, 7)
                .padding(.horizontal, 10)
            })
            .background(.separator, in: Rectangle())

            LazyVStack(alignment: .center, spacing: 0) {
                content()
            }
            .fontDesign(.monospaced)
        })
        .clipShape(RoundedRectangle(cornerRadius: 6))
        // .clipShape(ContainerRelativeShape())
        .overlay(
            // ContainerRelativeShape()
            RoundedRectangle(cornerRadius: 6)
                .stroke(.separator, lineWidth: 1)
        )
        .containerShape(RoundedRectangle(cornerRadius: 6))
        .background {
            RoundedRectangle(cornerRadius: 6)
                .fill(.windowBackground)
                .shadowLush()

//                .shadow(radius: 20, y: 16)
        }

    }
}
//
//#Preview {
//    FileView(fileStatus: .previewSwift) {
//        Text("content here.....")
//    }
//}
