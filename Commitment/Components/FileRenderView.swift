//
//  FileRenderView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI


struct FileRenderView: View {
    @EnvironmentObject private var repo: RepoState

    var fileStatus: GitFileStatus

    var body: some View {
        FileView(fileStatus: fileStatus) {
            if let path = String(fileStatus.path.split(separator: " -> ").last ?? "") {
                if let lines: [GitDiffHunkLine] = repo.shell.cat(file: path) {
                    ForEach(lines, id: \.self) { line in
                        DiffLineView(line: line)
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
