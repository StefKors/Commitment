//
//  ContentView.swift
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

fileprivate let log = Logger(subsystem: "com.stefkors.commitment", category: "FileMonitor")

/// TODO: I was converting Repostate to CodeRepository....
struct RepositoryWindow: View {
    let repository: CodeRepository

    @Environment(\.dismissWindow) private var dismissWindow
    // Repo Scoped App State
    @State private var folderMonitor: FolderContentMonitor? = nil
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
            print("run task")
//            if let path {
                //                dismissWindow(id: SceneID.welcomeWindow.id)
                do {

                    let url = try repository.bookmark.startUsingTargetURL()
                    repository.path = url
                    // TODO: re-save repo with update path?
                    self.shell = Shell(workspace: url)
                    NSDocumentController.shared.noteNewRecentDocumentURL(url)
                    startFolderMonitor(path: url)
                } catch {
                    print("failed to display repo: \(error.localizedDescription)")
                }
//            }
        }
    }

    func startFolderMonitor(path: URL) {
        if let folderMonitor {
            if folderMonitor.hasStarted {
                folderMonitor.stop()
            }
        }

        folderMonitor = FolderContentMonitor(url: path, latency: 1) { event in
            // TODO: Figure out better filtering... Perhaps based on .gitignore?
            // skip lock events
            if event.filename == "index.lock", event.filename == ".DS_Store" {
                return
            }

            let isGitFolderChange = event.eventPath.contains("/.git/")

            if isGitFolderChange, event.filename == "HEAD" {
                Throttler.throttle( delay: .seconds(3),shouldRunImmediately: true) {
                    log.debug("[File Change] Refreshing Branch \(event.url.lastPathComponent) (\(event.change))")
                    repository.refreshBranch()
                }
            }
            if !isGitFolderChange {
                Throttler.throttle( delay: .seconds(6),shouldRunImmediately: true, shouldRunLatest: false) {
                    Task(priority: .userInitiated, operation: {
                        log.debug("[File Change] \(event.url.lastPathComponent)")
                        try? await repository.refreshDiffsAndStatus()
                        //  TODO: Save repo changes to SwiftData
//                        try? await AppModel.shared.saveRepo(repo: self)
                    })
                }
            }
        }

        folderMonitor?.start()
    }
}

struct LoadedRepositoryWindow: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var repo: CodeRepository
    @EnvironmentObject private var activityState: ActivityState
    @EnvironmentObject private var undoState: UndoState
    @EnvironmentObject private var viewState: ViewState
    @EnvironmentObject private var shell: Shell

    @State private var showPanel: Bool = false
    var body: some View {
        HStack {
            MainRepoContentView()
            // .navigationDocument(URL(fileURLWithPath: state.repo.path.absoluteString, isDirectory: true))
        }
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
        .navigationSubtitle(repo.branch?.name.fullName ?? "")
    }
}

#Preview {
    LoadedRepositoryWindow()
}
