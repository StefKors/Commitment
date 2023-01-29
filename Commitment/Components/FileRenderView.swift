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

    @State private var lines: [GitDiffHunkLine] = []
    @State private var path: String = ""

    var body: some View {
        FileView(fileStatus: fileStatus) {
                if let lines {
                    ForEach(lines, id: \.id) { line in
                        DiffLineView(line: line)
                    }
                } else {
                    Text("Could not read file at \(path)")
                }
        }
        .id(fileStatus.path)
        .task(priority: .background) {
            self.path = String(fileStatus.path.split(separator: " -> ").last ?? "")
            self.lines = repo.shell.show(file: path, defaultType: fileStatus.diffModificationState)
        }
    }
}

// struct FileRenderView_Previews: PreviewProvider {
//     static var previews: some View {
//         FileRenderView(path: "TBD preview content file")
//     }
// }
