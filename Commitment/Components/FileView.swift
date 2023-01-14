//
//  FileView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI
import Git

struct FileView<Content: View>: View {
    var status: GitFileStatus

    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            VStack(alignment: .leading, content: {
                VStack(alignment: .leading, content: {
                    GitFileStatusView(status: status)
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
        .background(
            RoundedRectangle(cornerRadius: 6)
                .stroke(.separator, lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .textSelection(.enabled)
    }

}

// struct FileView_Previews: PreviewProvider {
//     static var previews: some View {
//         FileView()
//     }
// }