//
//  FileView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI


struct FileView<Content: View>: View {
    var fileStatus: GitFileStatus

    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            VStack(alignment: .leading, content: {
                VStack(alignment: .leading, content: {
                    GitFileStatusView(fileStatus: fileStatus)
                })
                .padding(.top, 7)
                .padding(.horizontal, 10)

                Divider()
            })
            .background(.separator)

            VStack(alignment: .leading, spacing: 0) {
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
    }
}

// struct FileView_Previews: PreviewProvider {
//     static var previews: some View {
//         FileView()
//     }
// }
