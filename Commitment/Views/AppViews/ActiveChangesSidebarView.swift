//
//  ActiveChangesSidebarView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI
import SwiftData

fileprivate struct ContextMenuContent: View {
    let fileStatus: GitFileStatus
    @Environment(CodeRepository.self) private var repository
    @AppStorage(Settings.Editor.ExternalEditor) private var externalEditor: ExternalEditor = ExternalEditors.xcode

    var body: some View {
        Button("Reveal in Finder") {
            if let last = fileStatus.path.split(separator: " -> ").last {
                let fullPath = self.repository.path.appending(path: last)
                fullPath.showInFinder()
            }
        }
        .keyboardShortcut("o")

        Button("Open in \(externalEditor.name)") {
            if let last = fileStatus.path.split(separator: " -> ").last {
                let fullPath = self.repository.path.appending(path: last)
                fullPath.openInEditor(externalEditor)
            }
        }
        .keyboardShortcut("o", modifiers: [.command, .shift])

        Divider()

        Button("Copy File Path") {
            if let last = fileStatus.path.split(separator: " -> ").last {
                let fullPath = self.repository.path.appending(path: last)
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
                await self.repository.discardActiveChange(path: fileStatus.path)
            }
        } label: {
            Text("Discard Changes")
        }
    }
}

struct ActiveChangesSidebarView: View {
    @Environment(CodeRepository.self) private var repository
    @EnvironmentObject private var viewState: ViewState

    var sortedStatus: [GitFileStatus] {
        self.repository.status.sorted(by: \.cleanedPath)
    }

    var body: some View {
        VStack {
            List(sortedStatus, id: \.path, selection: $viewState.activeChangeSelection) { fileStatus in
                SidebarGitFileStatusView(fileStatus: fileStatus)
                    .contextMenu {
                        ContextMenuContent(fileStatus: fileStatus)
                    }
                    .tag(fileStatus.id)
            }

            ActiveChangesStatsView()
            Divider()
            VStack {
                TextEditorView(isDisabled: self.repository.status.isEmpty)
                UndoActivityView()
            }
            .padding(.bottom)
        }
        .task(id: viewState.activeChangeSelection) {
            // Set default selection
            if viewState.activeChangeSelection == nil && self.sortedStatus.isNotEmpty {
                viewState.activeChangeSelection = self.sortedStatus.first?.id
            }
        }
    }
}






