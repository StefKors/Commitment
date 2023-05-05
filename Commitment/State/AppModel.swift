//
//  AppModel.swift
//  Commitment
//
//  Created by Stef Kors on 28/02/2023.
//

import SwiftUI
import Boutique
import Foundation
import KeyboardShortcuts

class AppModel: ObservableObject {
    static let shared = AppModel()
    @StoredValue(key: "Editor") var editor: ExternalEditor = .xcode
    @StoredValue(key: "WindowMode") var windowMode: SplitModeOptions = .history
    @StoredValue(key: "ActiveRepository") var activeRepositoryId: RepoState.ID? = nil
    /// Creates a @Stored property to handle an in-memory and on-disk cache of type.
    @Stored(in: .repositoryStore) var repos
    @Published var isRepoSelectOpen: Bool = false {
        didSet {
            if isRepoSelectOpen {
                isBranchSelectOpen = false
            }
        }
    }
    @Published var isBranchSelectOpen: Bool = false {
        didSet {
            if isBranchSelectOpen {
                isRepoSelectOpen = false
            }
        }
    }

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

    @MainActor
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

    func dismissModal() {
        self.isRepoSelectOpen = false
    }
}
