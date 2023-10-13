//
//  ActiveChangesSidebarView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI


struct ActiveChangesSidebarView: View {
    @EnvironmentObject private var repo: CodeRepository
    @EnvironmentObject private var viewState: ViewState

    var body: some View {
        VStack {
            List(selection: $viewState.activeChangesSelection) {
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

                            Button("Open in \(repo.editor.rawValue)") {
                                if let last = fileStatus.path.split(separator: " -> ").last {
                                    let fullPath = repo.path.appending(path: last)
                                    fullPath.openInEditor(repo.editor)
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
                        }
                        .tag(fileStatus.id)
                }
            }
            .listStyle(SidebarListStyle())

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






