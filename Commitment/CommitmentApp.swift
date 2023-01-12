//
//  CommitmentApp.swift
//  Commitment
//
//  Created by Stef Kors on 06/04/2022.
//

import SwiftUI

@main
struct CommitmentApp: App {
    @StateObject var git = GitClient(workspace: "~/Developer/Commitment")
    @StateObject var model = RepositoriesModel()

    var body: some Scene {

        WindowGroup("Difference", id: "RepoWindow", for: Repo.self) { $repo in
            if let repo = repo {
                RepoWindow()
                    .environmentObject(WindowState(repo))
                    .environmentObject(model)
                    .environmentObject(git)
            } else {
                WelcomeWindow()
                    .environmentObject(model)
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

        // WindowGroup {
        //     ContentView()
        //         .ignoresSafeArea()
        //         .environmentObject(git)
        //         .presentedWindowStyle(.hiddenTitleBar)
        //         .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification), perform: { _ in
        //             NSApp.mainWindow?.standardWindowButton(.zoomButton)?.isHidden = true
        //             NSApp.mainWindow?.standardWindowButton(.closeButton)?.isHidden = true
        //             NSApp.mainWindow?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        //             NSApp.mainWindow?.toolbar = nil
        //         })
        // }
        // .windowStyle(.hiddenTitleBar)
        // .windowResizability(.contentSize)
        // .defaultPosition(.center)
    }
}
