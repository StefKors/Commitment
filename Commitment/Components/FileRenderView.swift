//
//  FileRenderView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI
import Git

struct FileRenderView: View {
    @EnvironmentObject private var repo: RepoState

    var status: GitFileStatus

    var body: some View {
        FileView(status: status) {
            if let path = String(status.path.split(separator: " -> ").last ?? "") {
                if let file = repo.shell.cat(file: path) {
                    ForEach(file.split(separator: "\n"), id: \.self) { line in
                        DiffLineView(line: GitDiffHunkLine(type: .unchanged, text: String(line)))
                    }
                } else {
                    Text("Could not read file at \(path)")
                }
            }
        }
    }
}

// struct FileRenderView_Previews: PreviewProvider {
//     static var previews: some View {
//         FileRenderView(path: "TBD preview content file")
//     }
// }
