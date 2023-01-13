//
//  RepoState.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import Foundation
import Git
import Defaults
import SwiftUI
// https://developer.apple.com/documentation/appkit/nscolor/3000782-controlaccentcolor

extension Defaults.Keys {
    static let repos = Key<[RepoState]>("repos", default: [])
}

class RepoState: Defaults.Serializable, Codable, Equatable, Hashable, RawRepresentable, Identifiable, ObservableObject {
    var repository: GitRepository?
    var shell: Shell

    var monitor: FolderContentMonitor? = nil

    var path: URL

    var folderName: String {
        path.lastPathComponent
    }

    var branch: RepositoryReference? = nil

    @Published var diffs: [GitDiff] = []
    @Published var status: GitFileStatusList? = nil
    @Published var commits: [GitLogRecord]? = nil

    var task: Task<(), Never>?
    /// Debounce Source: https://stackoverflow.com/a/74794440/3199999
    private func debounce(interval: Duration = .nanoseconds(10000), operation: @escaping () -> Void) {
        task?.cancel()
        task = Task {
            do {
                try await Task.sleep(for: interval)
                operation()
            } catch {
                // TODO
            }
        }
    }

    convenience init?(string: String) {
        guard let path = URL(string: string) else {
            return nil
        }

        self.init(path: path)
    }

    init?(path: URL) {
        self.path = path
        self.shell = Shell(workspace: path.absoluteString)
    }

    deinit {
        monitor?.stop()
    }

    func initializeFullRepo() {
        guard let repo = try? GitRepository(atPath: path.path())  else {
            print("can't open repo at \(path.absoluteString)")
            return
        }
        self.repository = repo

        monitor = FolderContentMonitor(url: path, latency: 0.1) { [weak self] event in
            // TODO: Figure out better filtering... Perhaps based on .gitignore?
            if event.filename != "index.lock" {
                self?.debounce(interval: .milliseconds(300), operation: { [weak self] in
                    // print("Folder contents changed at \(event.url) (\(event.change))")
                    self?.refreshRepoState()
                })
            }
        }
        monitor?.start()
        self.refreshRepoState()
    }

    /// Watch out for re-renders, can be slow
    func refreshRepoState() {
        /// Update on background thread
        Task(priority: .background) {
            let refsList = try? repository?.listReferences()
            self.branch = refsList?.currentReference
            let diffs = self.shell.diff()
            let status = try? repository?.listStatus()
            let commits = try? repository?.listLogRecords().records as? [GitLogRecord]

            /// Publish on main thread
            await MainActor.run {
                self.diffs = diffs
                self.status = status
                self.commits = commits
            }
        }
    }

    static func == (lhs: RepoState, rhs: RepoState) -> Bool {
        lhs.path == rhs.path
    }

    enum CodingKeys: String, CodingKey {
        case path = "path"
    }

    required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let path = try values.decode(URL.self, forKey: .path)
        // TODO: remove this force bang
        self.init(path: path)!
    }

    // RawRepresentable
    var rawValue: URL {
        path
    }

    required convenience init?(rawValue: URL) {
        // TODO: can probably stay url?
        self.init(path: rawValue)
    }

    // Identifiable
    var id: URL {
        path
    }
}
