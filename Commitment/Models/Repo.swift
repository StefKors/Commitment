//
//  Repo.swift
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
    static let repos = Key<[Repo]>("repos", default: [])
}

struct Repo: Defaults.Serializable, Codable, Equatable, Hashable, RawRepresentable, Identifiable {
    var repository: GitRepository

    var path: URL

    var folderName: String {
        path.lastPathComponent
    }

    var branch: RepositoryReference?

    init?(string: String) {
        guard let path = URL(string: string) else {
            return nil
        }

        self.init(path: path)
    }

    init?(path: URL) {
        guard let repo = try? GitRepository(atPath: path.absoluteString)  else {
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

        let refsList = try? repo.listReferences()

        // git branch –show-current
        self.repository = repo
        self.path = url
        self.branch = refsList?.currentReference
    }

    static func == (lhs: Repo, rhs: Repo) -> Bool {
        lhs.path == rhs.path
    }

    enum CodingKeys: String, CodingKey {
        case path = "path"
    }

    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let path = try values.decode(URL.self, forKey: .path)
        // TODO: remove this force bang
        self.init(path: path)!
    }

    // RawRepresentable
    var rawValue: URL {
        path
    }

    init?(rawValue: URL) {
        // TODO: can probably stay url?
        self.init(path: rawValue)
    }

    // Identifiable
    var id: URL {
        path
    }
}
