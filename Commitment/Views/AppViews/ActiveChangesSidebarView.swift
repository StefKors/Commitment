//
//  ActiveChangesSidebarView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI


struct ActiveChangesSidebarView: View {
    @EnvironmentObject private var repo: RepoState
    @EnvironmentObject private var model: AppModel

    var body: some View {
        VStack {
            List(selection: $repo.view.activeChangesSelection) {
                ForEach(repo.status, id: \.id) { fileStatus in
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

                            Divider()

                            Button {
                                Task {
                                    await repo.discardActiveChange(path: fileStatus.path)
                                }
                            } label: {
                                Text("Discard Changes")
                            }
                            .keyboardShortcut(.delete)
                        }
                        .tag(fileStatus.id)
                }
            }
            .listStyle(SidebarListStyle())
            .onDeleteCommand {
                Task {
                    await repo.discardActiveChange()
                }
            }

            ActiveChangesStatsView()
            Divider()
            VStack {
                TextEditorView(isDisabled: repo.diffs.isEmpty)
                UndoActivityView()
            }
            .padding(.bottom)
        }
    }
}






