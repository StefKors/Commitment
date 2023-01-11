//
//  RepositoriesModel.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import Foundation
import Defaults
import SwiftUI

class RepositoriesModel: ObservableObject {
    @Default(.repos) var repos

    func addRepo(_ repo: Repo) {
        if repos.contains(where: { $0.path == repo.path }) {
            print("chore: remove duplicates")
            repos = Array(Set(repos))
            return
        }

        print("added repo: \(repo)")
        repos.append(repo)
    }

    func openRepo() -> Repo? {
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
                if let repo = Repo(string: path) {
                    self.addRepo(repo)
                    return repo
                }
            }
        }

        return nil
    }

}
