//
//  CommitmentApp.swift
//  Commitment
//
//  Created by Stef Kors on 06/04/2022.
//

import SwiftUI
import Boutique
import Foundation

extension Store where Item == RepoState {
    // Initialize a Store
    static let repositoryStore = Store<RepoState>(
        storage: SQLiteStorageEngine.default(appendingPath: "RepositoryStore")
    )
}

/// theming?
// /.foregroundStyle(.blue, .green, Gradient(colors: [.red, .yellow]))
// /.backgroundStyle(.pink)


class AppModel: ObservableObject {
    static let shared = AppModel()
    @StoredValue(key: "WindowMode") var windowMode: SplitModeOptions = .history
    @StoredValue(key: "ActiveRepository") var activeRepositoryId: RepoState.ID? = nil
    /// Creates a @Stored property to handle an in-memory and on-disk cache of type.
    @Stored(in: .repositoryStore) var repos

    let bookmarks: Bookmarks = .init()
    init() {
        bookmarks.loadBookmarks()
    }
    
    
    /// Saves an type to the `Store` in memory and on disk.
    func saveRepo(repo: RepoState?) async throws {
        guard let repo else { return }
        try await self.$repos.insert(repo)
    }
    
    /// Removes one type from the `Store` in memory and on disk.
    func removeRepo(repo: RepoState) async throws {
        try await self.$repos.remove(repo)
    }
    
    /// Removes all of the types from the `Store` in memory and on disk.
    func clearAllrepos() async throws {
        try await self.$repos.removeAll()
    }

    func openRepo() {
        let openPanel = NSOpenPanel()
        openPanel.message = "Add repo"
        openPanel.prompt = "Add"
        openPanel.allowedContentTypes = [.folder]
        openPanel.allowsOtherFileTypes = false
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true

        let response = openPanel.runModal()
        if response == .OK {
            if let url = openPanel.url {
                self.bookmarks.storeFolderInBookmark(url: url)
                let repo = RepoState(path: url)
                Task {
                    try? await saveRepo(repo: repo)
                }
                $activeRepositoryId.set(repo.id)
            }
        }

        return
    }
}

// https://reichel.dev/blog/swift-global-key-binding.html#install-hotkey
@main
struct CommitmentApp: App {
    @StateObject var appModel: AppModel = .shared
    @State private var repo: RepoState?
    var body: some Scene {
        Window("Commitment", id: "main window", content: {
            Group {
                if appModel.repos.isEmpty {
                    // Appicon view is slow?
                    // repos list is slow?
                    WelcomeWindow()
                        .frame(minWidth: 400, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
                    // .navigationTitle("Commitment")
                } else if let repo {
                    RepoWindow()
                        .environmentObject(repo)
                } else {
                    EmptyView()
                }
            }
            .environmentObject(appModel)
            .onReceive(appModel.activeRepositoryId.publisher, perform: { newVal in
                let repo = appModel.repos.first(with: appModel.activeRepositoryId) ?? appModel.repos.first
                guard let repo else { return }

                self.repo = repo
                repo.initializeFullRepo()
                repo.refreshBranch()
                repo.refreshDiffsAndStatus()
                repo.startMonitor()
            })

        })
        // .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact(showsTitle: true))
        .windowResizability(.contentMinSize)
        .commands {
            SidebarCommands()
        }
        
        Settings {
            SettingsWindow()
        }
        .windowStyle(.automatic)
        .windowToolbarStyle(.unified)
        .windowResizability(.contentMinSize)
    }
}
