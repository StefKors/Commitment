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
    @State private var content: String = ""
    @State private var finishedFetching: Bool = false

    var body: some View {
        Group {
            if finishedFetching {
                FileView(fileStatus: fileStatus) {
                    if !lines.isEmpty {
                        ForEach(lines, id: \.id) { line in
                            DiffLineView(line: line)
                                .id(line.id)
                        }
                    } else {
                        Text("Could not read file at \(path)")
                    }
                }
            }
        }
        .id(fileStatus.path)
        .task {
            self.path = String(fileStatus.path.split(separator: " -> ").last ?? "")
            do {
                self.lines = try await repo.shell.show(file: path, defaultType: fileStatus.diffModificationState)
                self.content = try repo.readFile(at: path)
                self.finishedFetching = true
            } catch {
                print("Failed at FileRenderView: \(error.localizedDescription)")
            }
        }
    }
}

// struct FileRenderView_Previews: PreviewProvider {
//     static var previews: some View {
//         FileRenderView(path: "TBD preview content file")
//     }
// }
