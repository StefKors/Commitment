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
    @EnvironmentObject private var repository: CodeRepository
    @EnvironmentObject private var activityState: ActivityState
    @EnvironmentObject private var undoState: UndoState
    @EnvironmentObject private var viewState: ViewState
    @EnvironmentObject private var shell: Shell
    @EnvironmentObject private var activeChangesState: ActiveChangesState

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
                    .environmentObject(repository)
                    .environmentObject(activityState)
                    .environmentObject(viewState)
                    .environmentObject(undoState)
                    .environmentObject(shell)
                    .environmentObject(activeChangesState)
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
                let commits = await self.shell.log()

                let options = LogOptions(compareReference: .init(lhsReferenceName: "origin/HEAD", rhsReferenceName: "HEAD"))
                let localCommits = await self.shell.log(options: options, isLocal: true)

                if commits.isNotEmpty {
                    let mergedCommits = commits.merge(localCommits)
                    self.repository.commits = mergedCommits
                    self.repository.commitsAhead = localCommits
                }
            }
            .task($activeChangesUpdate) {
                let diffs = await self.shell.diff()
                let status = await self.shell.status()

                activeChangesState.diffs = diffs
                activeChangesState.status = status
            }
    }
}

#Preview {
    LoadedRepositoryView()
}
