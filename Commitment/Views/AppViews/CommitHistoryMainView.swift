//
//  CommitHistoryMainView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI


struct CommitHistoryMainView: View {
    @EnvironmentObject private var model: AppModel
    @EnvironmentObject private var repo: RepoState
    var id: Commit.ID? = nil

    @State private var diffs: [GitDiff] = []
    @State private var files: [GitFileStatus] = [] {
        // set default view
        didSet {
            if repo.view.activeCommitFileSelection == nil {
                repo.view.activeCommitFileSelection = files.first?.id
            }
        }
    }

    var body: some View {
        HSplitView {
            ZStack {
                Rectangle().fill(.background)
                List(selection: $repo.view.activeCommitFileSelection) {
                    ForEach(files) { fileStatus in
                        GitFileStatusView(fileStatus: fileStatus)
                            .contextMenu {
                                Button("Reveal in Finder") {
                                    if let last = fileStatus.path.split(separator: " -> ").last {
                                        let fullPath = repo.path.appending(path: last)
                                        fullPath.showInFinder()
                                    }
                                }
                                .keyboardShortcut("o")

                                Button("Open in \(model.editor.name)") {
                                    if let last = fileStatus.path.split(separator: " -> ").last {
                                        let fullPath = repo.path.appending(path: last)
                                        fullPath.openInEditor(model.editor)
                                    }
                                }
                                .keyboardShortcut("o", modifiers: [.command, .shift])

                                Divider()

                                Button("Copy File Path") {
                                    if let last = fileStatus.path.split(separator: " -> ").last {
                                        let fullPath = repo.path.appending(path: last)
                                        copyToPasteboard(text: fullPath.relativePath)
                                    }
                                }
                                .keyboardShortcut("c")

                                Button("Copy Relative File Path") {
                                    if let last = fileStatus.path.split(separator: " -> ").last {
                                        copyToPasteboard(text: String(last))
                                    }
                                }
                                .keyboardShortcut("c", modifiers: [.command, .shift])
                            }
                            .tag(fileStatus.id)
                    }
                }
                .listStyle(SidebarListStyle())
                .ignoresSafeArea(.all, edges: .top)
            }
            .frame(minWidth: 300, idealWidth: 300, maxWidth: 500)
            .task(id: id, priority: .userInitiated) {
                if let id {
                    // TODO: is this the right way to do paralell?
                    if let diffs = try? await repo.shell.diff(at: id) {
                        self.diffs = diffs
                    }

                    if let newFiles = try? await repo.shell.show(at: id) {
                        repo.view.activeCommitFileSelection = nil
                        self.files = newFiles
                    }
                }
            }

            CommitHistoryDetailView(commitId: id, fileStatusId: repo.view.activeCommitFileSelection, files: files, diffs: diffs)
                .ignoresSafeArea(.all, edges: .top)
                .frame(minWidth: 300)
        }
    }
}
