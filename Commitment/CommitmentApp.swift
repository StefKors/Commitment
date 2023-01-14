//
//  CommitmentApp.swift
//  Commitment
//
//  Created by Stef Kors on 06/04/2022.
//

import SwiftUI

@main
struct CommitmentApp: App {

    var body: some Scene {
        WindowGroup("Commitment", id: "RepoWindow", for: RepoState.self) { $repo in
            if let repo = repo {
                RepoWindow()
                    .environmentObject(repo)
                    .environmentObject(WindowState(repo))
            } else {
                WelcomeWindow()
                    .environmentObject(WindowState())
            }
        }
        .windowStyle(.automatic)
        .windowToolbarStyle(.unified)
        .windowResizability(.contentMinSize)

        Settings {
            SettingsWindow()
        }
        .windowStyle(.automatic)
        .windowToolbarStyle(.unified)
        .windowResizability(.contentMinSize)
    }
}
