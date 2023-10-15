//
//  RepositoryWindow.swift
//  Difference
//
//  Created by Stef Kors on 12/08/2022.
//

import SwiftUI
import KeychainAccess
import KeyboardShortcuts
import SwiftData
import WindowManagement
import OSLog
import TaskTrigger

fileprivate let log = Logger(subsystem: "com.stefkors.commitment", category: "GitFileMonitor")

/// TODO: I was converting Repostate to CodeRepository....
struct RepositoryWindow: View {
    let repository: CodeRepository

    @Environment(\.dismissWindow) private var dismissWindow

    // TODO: merge activity state and shell?
    // TODO: shell should be stateObject otherwise updates won't work?
    @State private var shell: Shell? = nil
    @StateObject private var activityState = ActivityState()
    @StateObject private var viewState = ViewState()
    @StateObject private var undoState = UndoState()

    var body: some View {
        VStack {
            if shell != nil, let shell {
                LoadedRepositoryWindow()
                    .environmentObject(repository)
                    .environmentObject(activityState)
                    .environmentObject(viewState)
                    .environmentObject(undoState)
                    .environmentObject(shell)
                    .navigationDocument(repository.path)
            } else {
                Text("failed to open repository")
            }
        }
        .task(id: repository) {
            do {
                let url = try repository.bookmark.startUsingTargetURL()
                repository.path = url
                // TODO: re-save repo with update path?
                self.shell = Shell(workspace: url)
                NSDocumentController.shared.noteNewRecentDocumentURL(url)
            } catch {
                log.error("failed to restore bookmark: \(error.localizedDescription)")
            }
        }
    }
}

struct LoadedRepositoryWindow: View {
    @EnvironmentObject private var repo: CodeRepository
    @EnvironmentObject private var activityState: ActivityState
    @EnvironmentObject private var undoState: UndoState
    @EnvironmentObject private var viewState: ViewState
    @EnvironmentObject private var shell: Shell

    // Repo Scoped App State
    @State private var folderMonitor: FolderContentMonitor? = nil
    @State private var branchUpdate = PlainTaskTrigger()
    @State private var activeChangesUpdate = PlainTaskTrigger()

    @State private var showPanel: Bool = false
    var body: some View {
        MainRepoContentView()
            .touchBar(content: {
                TouchbarContentView()
            })
            .floatingPanel(isPresented: $showPanel) {
                QuickCommitPanelView(showPanel: $showPanel)
                    .environmentObject(repo)
                    .environmentObject(activityState)
                    .environmentObject(viewState)
                    .environmentObject(undoState)
                    .environmentObject(shell)
            }
            .onKeyboardShortcut(.globalCommitPanel, type: .keyDown, perform: {
                self.showPanel.toggle()
            })
            .frame(minWidth: 940)
            .navigationTitle(repo.folderName)
            .task(id: repo.path, {
                branchUpdate.trigger()
            })
            .gitFolderMonitor(repo.path) { fileChange in
                Throttler.throttle( delay: .seconds(6),shouldRunImmediately: true, shouldRunLatest: false) {
                    //  TODO: Save repo changes to SwiftData
                    Task(priority: .userInitiated, operation: {
                        activeChangesUpdate.trigger()
                    })
                }
            } onGitChange: { gitChange in
                Throttler.throttle( delay: .seconds(3),shouldRunImmediately: true) {
                    branchUpdate.trigger()
                }
            }
            .task($branchUpdate) {
                repo.branches = await shell.listReferences()
                    .uniqued(on: \.id).sorted(by: { branchA, branchB in
                        return branchA.date > branchB.date
                    })
                log.info("\(repo.branches.count.description)")
            }
            .task($activeChangesUpdate) {

            }
            .task($activeChangesUpdate) {
                let diffs = try await self.shell.diff()
                let status = try await self.shell.status()
                let commits = try await getCommits()
                let localCommits = try await getLocalCommits()
                /// Publish on main thread
                await MainActor.run {
                    self.diffs = diffs
                    self.status = status
                    if let commits, let localCommits {
                        let mergedCommits = commits.merge(localCommits)
                        self.commits = mergedCommits
                        self.commitsAhead = localCommits
                    }
                    self.lastUpdate = .now
                }
                //            let result = await try? shell.branch()
            }
    }
}

#Preview {
    LoadedRepositoryWindow()
}
