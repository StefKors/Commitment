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
    var repository: GitRepository
    var shell: Shell

    var path: URL

    var folderName: String {
        path.lastPathComponent
    }

    var branch: RepositoryReference? = nil

    @Published var diffs: [GitDiff] = []
    @Published var status: GitFileStatusList? = nil
    @Published var commits: [GitLogRecord]? = nil

    convenience init?(string: String) {
        guard let path = URL(string: string) else {
            return nil
        }

        self.init(path: path)
    }

    init?(path: URL) {
        guard let repo = try? GitRepository(atPath: path.path())  else {
            print("can't open repo at \(path.absoluteString)")
            return nil
        }
        guard let localPath = repo.localPath  else {
            print("can't open localpath at \(path.absoluteString)")
            return nil
        }
        guard let url = URL(string: localPath) else {
            print("can't open url at \(path.absoluteString)")
            return nil
        }

        // git branch –show-current
        self.repository = repo
        self.path = url
        self.shell = Shell(workspace: path.absoluteString)
        self.refreshRepoState()
    }

    /// Watch out for re-renders, can be slow
    func refreshRepoState() {
        print("BEFORE: updating repo state \(commits?.count ?? 0)")
        let refsList = try? repository.listReferences()
        self.branch = refsList?.currentReference
        self.diffs = self.shell.diff()
        self.status = try? repository.listStatus()
        self.commits = try? repository.listLogRecords().records as? [GitLogRecord]
        print("AFTER: updating repo state \(commits?.count ?? 0)")
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
