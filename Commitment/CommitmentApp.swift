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

final class AppModel: ObservableObject {
    @StoredValue(key: "WindowMode") var windowMode: SplitModeOptions = .history
    @StoredValue(key: "ActiveRepository") var activeRepositoryId: RepoState.ID? = nil
    /// Creates a @Stored property to handle an in-memory and on-disk cache of type.
    @Stored(in: .repositoryStore) var repos
    
    
    /// Saves an type to the `Store` in memory and on disk.
    func saveRepo(repo: RepoState) async throws {
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
            if let path = openPanel.url?.path() {
                if let repo = RepoState(string: path) {
                    Task {
                        try? await saveRepo(repo: repo)
                    }
                    $activeRepositoryId.set(repo.id)
                }
            }
        }

        return
    }
}

@main
struct CommitmentApp: App {
    @StateObject var appModel: AppModel = AppModel()
    @State private var repo: RepoState?

    var body: some Scene {
        Window("Commitment", id: "main window", content: {
            Group {
                if let repo {
                    RepoWindow()
                        .environmentObject(repo)
                } else {
                    WelcomeWindow()
                        .frame(minWidth: 400, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
                        .navigationTitle("Commitment")
                        .navigationSubtitle("")
                }
            }
            .environmentObject(appModel)
            .onReceive(appModel.$repos.$items, perform: {
                print("print: \($0.debugDescription)")
                // TODO: update db when things update
                // We can even create complex pipelines, for example filtering all notes bigger than a tweet
                self.repo = $0.first(with: appModel.activeRepositoryId) ?? $0.first
            })
        })
        .windowStyle(.automatic)
        .windowToolbarStyle(.unified)
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
