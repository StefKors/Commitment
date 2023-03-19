//
//  RepoState.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import Foundation
import SwiftUI
import Boutique
import Algorithms
// https://developer.apple.com/documentation/appkit/nscolor/3000782-controlaccentcolor

extension Store where Item == RepoState {
    // Initialize a Store
    static let repositoryStore = Store<RepoState>(
        storage: SQLiteStorageEngine.default(appendingPath: "RepositoryStore")
    )
}

class RepoState: Codable, Equatable, Identifiable, ObservableObject {
    @Published var activity = ActivityState()
    @Published var view = ViewState()

    var shell: Shell

    var monitor: FolderContentMonitor? = nil

    var path: URL

    var folderName: String {
        path.lastPathComponent
    }

    var branch: String = ""
    var branches: [GitReference] = []

    @Published var diffs: [GitDiff] = []
    @Published var status: [GitFileStatus] = [] {
        // set default view
        didSet {
            if view.activeChangesSelection == nil {
                view.activeChangesSelection = status.first?.id
            } else if !status.contains(where: { filestatus in
                view.activeChangesSelection != filestatus.id
            }) {
                view.activeChangesSelection = status.first?.id
            }
        }
    }

    @Published var commits: [Commit] = [] {
        // set default view
        didSet {
            if view.activeCommitSelection == nil {
                view.activeCommitSelection = commits.first?.id
            } else if !commits.contains(where: { commit in
                view.activeCommitSelection != commit.id
            }) {
                view.activeCommitSelection = status.first?.id
            }
        }
    }
    @Published var commitsAhead: Int = 0
    @Published var lastFetchedDate: Date? = nil

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

    convenience init(path: URL, commits: [Commit], status: [GitFileStatus], diffs: [GitDiff]) {
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
            if !isGitFolderChange {
                Throttler.throttle( delay: .seconds(6),shouldRunImmediately: true, shouldRunLatest: false) { [weak self] in
                    self?.activity.start(.isRefreshingState)
                    print("[File Change] \(event.url.lastPathComponent)")
                    Task(priority: .userInitiated, operation: { [weak self] in
                        try? await self?.refreshDiffsAndStatus()
                        try? await AppModel.shared.saveRepo(repo: self)
                        self?.activity.finish(.isRefreshingState)
                    })
                }
            }
        }

        monitor?.start()
    }

    /// Watch out for re-renders, can be slow
    func refreshRepoState() async throws {
        refreshBranch()
        try await refreshDiffsAndStatus()
        await updateLastFetched()
    }

    func updateLastFetched() async {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: path.path() + "/.git/FETCH_HEAD") {
            await MainActor.run {
                self.lastFetchedDate = attributes[.modificationDate] as? Date
            }
        }
    }

    /// Watch out for re-renders, can be slow
    func refreshDiffsAndStatus() async throws {
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
                self.commitsAhead = localCommits.count
            }
        }
    }

    private func getCommits() async throws -> [Commit]? {
        let commits = try? await self.shell.log()
        guard let commits else { return nil }
        return commits
    }

    private func getLocalCommits() async throws -> [Commit]? {
        let options = LogOptions()
        options.compareReference = .init(lhsReferenceName: "origin/HEAD", rhsReferenceName: "HEAD")
        let localCommits = try? await self.shell.log(options: options, isLocal: true)
        guard let localCommits else { return nil }


        return localCommits
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
                self.branches = refs?.uniqued(on: \.id).sorted(by: { branchA, branchB in
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
        let commits = try values.decode([Commit].self, forKey: .commits)
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
