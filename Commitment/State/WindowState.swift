//
//  WindowState.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import Foundation
import Defaults
import SwiftUI

class WindowState: ObservableObject {
    @Published var repo: RepoState?

    init (_ repo: RepoState? = nil) {
        self.repo = repo
    }

    func addRepo(_ repo: RepoState) {
        if Defaults[.repos].contains(where: { $0.path == repo.path }) {
            print("chore: remove duplicates")
            Defaults[.repos] = Array(Set(Defaults[.repos]))
            return
        }

        print("added repo: \(repo)")
        Defaults[.repos].append(repo)
    }

    func openRepo() -> RepoState? {
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
                    self.addRepo(repo)
                    return repo
                }
            }
        }

        return nil
    }
}
