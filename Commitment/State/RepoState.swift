//
//  RepoState.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import Foundation
import SwiftUI
import Boutique
// https://developer.apple.com/documentation/appkit/nscolor/3000782-controlaccentcolor

class RepoState: Codable, Equatable, Identifiable, ObservableObject {
    @Published var activity = ActivityState()

    var shell: Shell

    var monitor: FolderContentMonitor? = nil

    var path: URL

    var folderName: String {
        path.lastPathComponent
    }

    var branch: String = ""
    var branches: [RepositoryReference] = []

    @Published var diffs: [GitDiff] = []
    @Published var status: [GitFileStatus] = []
    @Published var commits: [GitLogRecord] = []

    @Published var commitsAhead: Int = 0

    init(path: URL) {
        self.path = path
        self.shell = Shell(workspace: path.absoluteString)
        Task {
            let branch = try? await shell.branch()
            if let branch {
                self.branch = branch
            }
        }
    }

    convenience init(path: URL, commits: [GitLogRecord], status: [GitFileStatus], diffs: [GitDiff]) {
        self.init(path: path)
        self.commits = commits
        self.status = status
        self.diffs = diffs
        print("""
init RepoState: \(folderName) with:
    - \(commits.count) commits
    - \(status.count) status files
    - \(diffs.count) diffs
""")
    }

    deinit {
        monitor?.stop()
    }

    func startMonitor() {
        monitor = FolderContentMonitor(url: path, latency: 1) { [weak self] event in
            // TODO: Figure out better filtering... Perhaps based on .gitignore?
            // skip lock events
            // print("[File Change] Refreshing Branch \(event.url.lastPathComponent) (\(event.change))")
            if event.filename == "index.lock", event.filename == ".DS_Store" {
                return
            }
        
            let isGitFolderChange = event.eventPath.contains("/.git/")
        
            if isGitFolderChange, event.filename == "HEAD" {
                Throttler.throttle( delay: .seconds(3),shouldRunImmediately: true) {
                    print("[File Change] Refreshing Branch \(event.url.lastPathComponent) (\(event.change))")
                    self?.refreshBranch()
                }
            }
            // if !isGitFolderChange {
                Throttler.throttle( delay: .seconds(6),shouldRunImmediately: true, shouldRunLatest: false) {
                    self?.activity.start(.isRefreshingState)
                    print("[File Change] \(event.url.lastPathComponent)")
                    self?.refreshDiffsAndStatus()
                    let copy = self
                    Task(priority: .userInitiated, operation: { [weak self] in
                        try? await AppModel.shared.saveRepo(repo: copy)
                        self?.activity.finish(.isRefreshingState)
                    })
                }
            // }
        }

        monitor?.start()
    }

    /// Watch out for re-renders, can be slow
    func refreshRepoState() {
        refreshBranch()
        refreshDiffsAndStatus()
    }

    /// Watch out for re-renders, can be slow
    func refreshDiffsAndStatus() {
        /// TODO: this should run paralell
        /// Update on background thread
        Task {
            let diffs = try? await self.shell.diff()
            let status = try? await self.shell.status()
            let commits = try? await getCommits()
            let localCommits = try? await getLocalCommits()
            /// Publish on main thread
            await MainActor.run {
                if let diffs {
                    self.diffs = diffs
                }
                if let files = status?.files {
                    self.status = files
                }
                if let commits, let localCommits {
                    let mergedCommits = commits.merge(localCommits)
                    self.commits = mergedCommits
                    self.commitsAhead = localCommits.count
                }
            }
        }
    }

    private func getCommits() async throws -> [GitLogRecord]? {
        let commits = try? await self.shell.listLogRecords().records
        guard let commits else { return nil }
        return commits
    }

    private func getLocalCommits() async throws -> [GitLogRecord]? {
        let options = GitLogOptions()
        options.compareReference = .init(lhsReferenceName: "origin/HEAD", rhsReferenceName: "HEAD")
        let localCommits = try? await self.shell.listLogRecords(options: options).records
        guard let localCommits else { return nil }

        let updatedLocalCommits = localCommits.map { localCommit in
            localCommit.isLocal = true
            return localCommit
        }

        return updatedLocalCommits
    }

    func refreshBranch() {
        /// Update on background thread
        Task(priority: .utility) {
            let branch = try? await self.shell.branch()
            let refs = try? await shell.listReferences()
            /// Publish on main thread
            await MainActor.run {
                if let branch {
                    self.branch = branch
                }
                self.branches = refs?.localBranches.sorted(by: { branchA, branchB in
                    return branchA.date > branchB.date
                }) ?? []
            }
        }
    }

    func readFile(at path: String) throws -> String {
        try String(contentsOf: URL(filePath: path), encoding: .utf8)
    }

    static func == (lhs: RepoState, rhs: RepoState) -> Bool {
        lhs.path == rhs.path
    }

    enum CodingKeys: String, CodingKey, CaseIterable {
        case path = "path"
        case commits = "commits"
        case status = "status"
        case diffs = "diffs"
    }

    /// Manual conformance due to persisting published properties
    /// https://www.hackingwithswift.com/books/ios-swiftui/adding-codable-conformance-for-published-properties
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(path, forKey: .path)
        try container.encode(commits, forKey: .commits)
        try container.encode(status, forKey: .status)
        try container.encode(diffs, forKey: .diffs)
    }

    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let path = try values.decode(URL.self, forKey: .path)
        let commits = try values.decode([GitLogRecord].self, forKey: .commits)
        let status = try values.decode([GitFileStatus].self, forKey: .status)
        let diffs = try values.decode([GitDiff].self, forKey: .diffs)
        self.init(
            path: path,
            commits: commits,
            status: status,
            diffs: diffs
        )
    }

    // Hashable
    public func hash(into hasher: inout Hasher) {
        // Dumb or ingenious?
        for key in RepoState.CodingKeys.allCases {
            hasher.combine(key)
        }
    }

    required convenience init?(rawValue: URL) {
        // TODO: can probably stay url?
        self.init(path: rawValue)
    }

    // Identifiable
    var id: String {
        return CacheKey(url: self.path).value
    }
}
