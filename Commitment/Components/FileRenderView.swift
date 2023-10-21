//
//  FileRenderView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI


struct FileRenderView: View {
    @Environment(CodeRepository.self) private var repository

    var fileStatus: GitFileStatus

    @State private var lines: [GitDiffHunkLine] = []
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
                        Text("Could not read file at \(fileStatus.cleanedPath)")
                    }
                }
            }
        }
        .task(id: fileStatus.stats) {
            let fullFileURL = URL(fileURLWithPath: fileStatus.cleanedPath, isDirectory: false, relativeTo: self.repository.path)
            if let content = try? self.repository.readFile(at: fullFileURL) {
                self.lines = content
                    .components(separatedBy: "\n")
                    .enumerated()
                    .map({ (index, line) in
                        return GitDiffHunkLine(
                            type: fileStatus.diffModificationState,
                            text: String(line),
                            oldLineNumber: index,
                            newLineNumber: index
                        )
                    })
            }
            self.finishedFetching = true
        }
    }
}
