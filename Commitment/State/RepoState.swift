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

    var diff: DiffState = DiffState()
    var status: StatusState = StatusState()
    var commits: CommitState = CommitState()

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
        let refsList = try? repository.listReferences()
        self.branch = refsList?.currentReference
        self.diff.diffs = self.shell.diff()
        self.status.status = try? repository.listStatus()
        self.commits.commits = try? repository.listLogRecords().records as? [GitLogRecord]
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
