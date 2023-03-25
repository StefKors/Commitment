//
//  GitFileStatusLabelView.swift
//  Commitment
//
//  Created by Stef Kors on 25/03/2023.
//

import SwiftUI

struct GitFileStatusLabelView: View {
    // For example: "Commitment/Views/Components/GitView.swift"
    let label: URL

    // For example: "Commitment/Views/Components/"
    var relativePath: String {
        label.deletingLastPathComponent().path(percentEncoded: false)
    }

    // For example: "GitView.swift"
    var file: String {
        label.lastPathComponent
    }

    // For example: "GitView"
    var name: String {
        String(file.split(separator: ".").first ?? "")
    }

    // For example: ".swift"
    var type: String {
        "." + label.pathExtension
    }


    var body: some View {
        HStack(spacing: 0) {
            Text(relativePath)
                .truncationMode(.tail)
                .foregroundColor(.secondary)
                .frame(minWidth: 20)
                .layoutPriority(1)

            Text(name)
                .truncationMode(.tail)
                .layoutPriority(2)

            Text(type)
                .layoutPriority(2)
        }
    }
}

struct GitFileStatusLabelView_Previews: PreviewProvider {
    static var previews: some View {
        GitFileStatusLabelView(label: URL(string: "Commitment/Views/Components/GitView.swift")!)
    }
}
