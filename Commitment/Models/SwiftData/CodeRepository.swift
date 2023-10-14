//
//  CodeRepository.swift
//  Commitment
//
//  Created by Stef Kors on 19/07/2023.
//

import SwiftUI
import SwiftData
import OSLog

fileprivate let log = Logger(subsystem: "com.stefkors.commitment", category: "CodeRepository")

struct NewShell {
    var workspace: URL

    init(workspace: URL) {
        self.workspace = workspace
    }
}

@Model final class CodeRepository: Identifiable, ObservableObject {
    @Attribute(.unique) var path: URL

    var bookmark: Bookmark
    // Settings
    var editor: ExternalEditors = ExternalEditors.xcode
    var windowMode: SplitModeOptions = SplitModeOptions.changes
//    var diffViewMode: DiffViewMode = DiffViewMode.unified
    var user: GitUser? = nil

    // Stored repo info
    var branches: [GitReference]
    var commits: [Commit]
    // TODO: remove?
    var commitsAhead: [Commit]

    // Current State
    // TODO: move to view state instead?
    var status: [GitFileStatus] = []
    var diffs: [GitDiff] = []

    // Computed properties for easy reference
    var branch: GitReference? {
        branches.first(where: \.active)
    }
    var folderName: String {
        path.lastPathComponent
    }

    init(path: URL) throws {
        self.path = path
        self.bookmark = try Bookmark(targetFileURL: path)

        self.editor = ExternalEditors.xcode
        self.windowMode = SplitModeOptions.changes

        // self.cli = NewShell(workspace: path)
//        self.editor = ExternalEditor.xcode
//        self.windowMode = SplitModeOptions.changes
//        self.diffViewMode = DiffViewMode.unified

        self.branches = []
        self.commits = []
        self.commitsAhead = []
    }
}

// MARK: - SwiftData Predicates
extension CodeRepository {
    static func predicate(url: URL) -> Predicate<CodeRepository> {
        return #Predicate<CodeRepository> { repository in
            repository.path == url
        }
    }
}

// TODO: Propagate changes through swift data instead of running methods here
extension CodeRepository {
    func refreshBranch() {
        /// Update on background thread
//        Task(priority: .utility) {
//            let branch = try? await self.shell.branch()
//            let refs = try? await shell.listReferences()
//            /// Publish on main thread
//            await MainActor.run {
//                if let branch {
//                    self.branch = branch
//                }
//                self.branches = refs?.uniqued(on: \.id).sorted(by: { branchA, branchB in
//                    return branchA.date > branchB.date
//                }) ?? []
//            }
//        }
    }
    
    /// Watch out for re-renders, can be slow
    func refreshDiffsAndStatus() async throws {
        log.warning("TODO: implement Refresh Diffs")
//        let diffs = try await self.shell.diff()
//        let status = try await self.shell.status()
//        let commits = try await getCommits()
//        let localCommits = try await getLocalCommits()
//        /// Publish on main thread
//        await MainActor.run {
//            self.diffs = diffs
//            self.status = status
//            if let commits, let localCommits {
//                let mergedCommits = commits.merge(localCommits)
//                self.commits = mergedCommits
//                self.commitsAhead = localCommits
//            }
//            self.lastUpdate = .now
//        }
    }

    /// Watch out for re-renders, can be slow
    func refreshRepoState() async throws {
//        refreshBranch()
//        try? await refreshDiffsAndStatus()
//        try? await refreshUser()
    }

    /// Creates a "Discard Change" stash so we have an do/undo trail
    func discardActiveChange() async {
//        if let selectedChange = self.view.activeChangesSelection?.split(separator: " -> ").first {
//            let path = String(selectedChange)
//            // git stash push --include-untracked -m "Discard Change" Commitment/State/Fileagain.swift
//            var message = "Discard Change"
//
//            let fileName = URL(filePath: path).lastPathComponent
//            if !fileName.isEmpty {
//                message = "Discard Change to \(fileName)"
//            }
//            let commands = ["stash", "push", "--include-untracked", "-m", message, path]
//            _ = try? await shell.runTask(.git, commands)
//
//            await MainActor.run {
//                let action = UndoAction(type: .discardChanges, arguments: commands)
//                self.undo.stack.append(action)
//            }
//        }
    }

    /// Creates a "Discard Change" stash so we have an do/undo trail
    func discardActiveChange(path: String) async {
//        if let selectedChange = path.split(separator: " -> ").first {
//            let path = String(selectedChange)
//            // git stash push --include-untracked -m "Discard Change" Commitment/State/Fileagain.swift
//            var message = "Discard Change"
//
//            let fileName = URL(filePath: path).lastPathComponent
//            if !fileName.isEmpty {
//                message = "Discard Change to \(fileName)"
//            }
//            let commands = ["stash", "push", "--include-untracked", "-m", message, path]
//            _ = try? await shell.runTask(.git, commands)
//
//            await MainActor.run {
//                let action = UndoAction(type: .discardChanges, arguments: commands)
//                self.undo.stack.append(action)
//            }
//        }
    }

    // TODO: finish this
    func discardAllChanges() async {
        // _ = try? await shell.run(.git, ["restore", "."])
    }

    func refreshUser() async throws {
//        self.user = try await self.shell.getGitUser()
    }

    // TODO: Move to a global actions state / environment functions or smth?
    func readFile(at path: String) throws -> String {
        try String(contentsOf: URL(filePath: path), encoding: .utf8)
    }

    func readFile(at url: URL) throws -> String {
        try String(contentsOf: url, encoding: .utf8)
    }
}
