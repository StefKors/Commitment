//
//  FileRenderView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI
import UniformTypeIdentifiers
import NukeUI

struct FileRenderView: View {
    @Environment(CodeRepository.self) private var repository

    let fileStatus: GitFileStatus

    @State private var lines: [GitDiffHunkLine] = []
    @State private var finishedFetching: Bool = false

    var url: URL {
        URL(filePath: fileStatus.cleanedPath, relativeTo: self.repository.path)
    }

    private var isImage: Bool {
        if let type = UTType(filenameExtension: url.pathExtension) {
            return type.conforms(to: UTType.image)
        }
        return false
    }

    var body: some View {
        Group {
            FileView(fileStatus: fileStatus) {
                if finishedFetching {
                    if !lines.isEmpty {
                        ForEach(lines, id: \.id) { line in
                            DiffLineView(line: line)
                                .id(line.id)
                        }
                    } else if isImage {
                        LazyImage(url: url) { state in
                            if let image = state.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(
                                        maxWidth: state.imageContainer?.image.size.width,
                                        maxHeight: state.imageContainer?.image.size.height
                                    )
                            }
                        }
                    } else {
                        // TODO: handle deleted files
                        Text("Could not read file at \(fileStatus.cleanedPath)")
                    }
                }
            }
        }
        .task(id: fileStatus) {
            self.finishedFetching = false

            let fullFileURL = URL(fileURLWithPath: fileStatus.cleanedPath, isDirectory: false, relativeTo: self.repository.path)
            guard let content = try? self.repository.readFile(at: fullFileURL) else {
                self.lines = []
                self.finishedFetching = true
                return
            }

            self.lines = content.lines
                .enumerated()
                .map({ (index, line) in
                    return GitDiffHunkLine(
                        type: fileStatus.diffModificationState,
                        text: String(line),
                        oldLineNumber: index,
                        newLineNumber: index
                    )
                })

            if fileStatus.diffModificationState == .deletion {
                fileStatus.stats = GitFileStats(
                    fileChanged: fileStatus.cleanedPath,
                    insertions: 0,
                    deletions: self.lines.count,
                    raw: ""
                )
            } else {
                fileStatus.stats = GitFileStats(
                    fileChanged: fileStatus.cleanedPath,
                    insertions: self.lines.count,
                    deletions: 0,
                    raw: ""
                )
            }

            self.finishedFetching = true
        }
    }
}
