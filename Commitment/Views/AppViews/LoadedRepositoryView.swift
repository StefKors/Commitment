//
//  LoadedRepositoryView.swift
//  Commitment
//
//  Created by Stef Kors on 15/10/2023.
//

import SwiftUI
import TaskTrigger
import Algorithms
import KeyboardShortcuts

struct LoadedRepositoryView: View {
    @Environment(CodeRepository.self) private var repository
    @EnvironmentObject private var activityState: ActivityState
    @EnvironmentObject private var undoState: UndoState
    @EnvironmentObject private var viewState: ViewState
    @EnvironmentObject private var shell: Shell

    // Updates Triggered by Folder Monitor
    @State private var gitBranchUpdate = PlainTaskTrigger()
    @State private var gitHistoryUpdate = PlainTaskTrigger()
    @State private var activeChangesUpdate = PlainTaskTrigger()

    // State for QuickComiit panel
    @State private var showPanel: Bool = false

    var body: some View {
        MainRepoContentView()
            .touchBar {
                TouchbarContentView()
            }
            .floatingPanel(isPresented: $showPanel) {
                QuickCommitPanelView(showPanel: $showPanel)
                    .environment(repository)
                    .environmentObject(activityState)
                    .environmentObject(viewState)
                    .environmentObject(undoState)
                    .environmentObject(shell)
            }
            .onKeyboardShortcut(.globalCommitPanel, type: .keyDown, perform: {
                self.showPanel.toggle()
            })
            .task(id: repository.path, {
                /// onload triggers
                gitBranchUpdate.trigger()
            })
            .gitFolderMonitor(
                url: repository.path,
                onFileChange: { fileChange in
                    Throttler.throttle(delay: .seconds(6),shouldRunImmediately: true, shouldRunLatest: false) {
                        // TODO: Save repo changes to SwiftData
                        Task(priority: .userInitiated, operation: {
                            activeChangesUpdate.trigger()
                        })
                    }
                },
                onGitChange: { gitChange in
                    Throttler.throttle( delay: .seconds(3),shouldRunImmediately: true) {
                        gitBranchUpdate.trigger()
                        gitHistoryUpdate.trigger()
                    }
                }
            )
            .task($gitBranchUpdate) {
                repository.branches = await shell.listReferences()
                    .uniqued(on: \.id)
                    .sorted(by: \.date, using: >)
            }
            .task($gitHistoryUpdate) {
                async let commits = self.shell.log()

                let options = LogOptions(compareReference: .init(lhsReferenceName: "origin/HEAD", rhsReferenceName: "HEAD"))
                async let localCommits = self.shell.log(options: options, isLocal: true)

                if await commits.isNotEmpty {
                    let mergedCommits = await commits.merge(localCommits)
                    self.repository.commits = mergedCommits
                    self.repository.commitsAhead = await localCommits
                }
            }
            .task($activeChangesUpdate) {
                let diffs: [String: GitDiff] = await self.shell.diff()

                let status = await self.shell.status().map { status in
                    status.diff = diffs[status.cleanedPath]
                    return status
                }

//                let updatedStatus: [GitFileStatus] = status.filter { status in
//                    !repository.status.contains(where: { existingFileStatus in
//                        status.id == existingFileStatus.id
//                    })
//                }
                print("updating status testing: ActiveChangesSidebarView")
                // TODO: why is this losing selection
//                repository.status.append(contentsOf: updatedStatus)
                repository.status = status
                repository.stats = await self.shell.stats()
            }
    }
}

#Preview {
    LoadedRepositoryView()
}
