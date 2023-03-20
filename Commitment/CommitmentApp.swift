//
//  CommitmentApp.swift
//  Commitment
//
//  Created by Stef Kors on 06/04/2022.
//

import SwiftUI
import Boutique
import Foundation
import WindowManagement

// https://github.com/Wouter01/SwiftUI-WindowManagement
// NSWindow.alwaysUseActiveAppearance = true
/// theming?
// /.foregroundStyle(.blue, .green, Gradient(colors: [.red, .yellow]))
// /.backgroundStyle(.pink)


// CLI tool for controlling the app
// https://www.youtube.com/watch?v=hPEDjbb_BD0
// https://reichel.dev/blog/swift-global-key-binding.html#install-hotkey
@main
struct CommitmentApp: App {
    @StateObject var appModel: AppModel = .shared
    @State private var repo: RepoState? = nil

    init() {
        NSWindow.alwaysUseActiveAppearance = true
    }

    var body: some Scene {
        Window("Commitment", id: "MainWindow", content: {
            Group {
                if let repo {
                    RepoWindow()
                        .ignoresSafeArea(.all, edges: .top)
                        .environmentObject(repo)
                } else {
                    WelcomeSheet()
                }
            }
            .environmentObject(appModel)
            .onReceive(appModel.activeRepositoryId.publisher, perform: { newVal in
                let repo = appModel.repos.first(with: appModel.activeRepositoryId) ?? appModel.repos.first
                guard let repo else { return }

                self.repo = repo
                Task {
                    do {
                        try await repo.refreshRepoState()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                repo.startMonitor()
            })
        })
        .register("MainWindow")
        .titlebarAppearsTransparent(true)
        .windowToolbarStyle(.unifiedCompact(showsTitle: false))
        .windowStyle(.hiddenTitleBar)
        // .windowStyle(.hiddenTitleBar)
        // .windowToolbarStyle(.unifiedCompact(showsTitle: true))
        .windowResizability(.contentMinSize)
        .commands {
            SidebarCommands()
        }

        Settings {
            SettingsWindow()
                .frame(width: 650, height: 400)
                .environmentObject(appModel)
        }
        .windowStyle(.automatic)
        .windowToolbarStyle(.unified)
        .windowResizability(.automatic)
        .defaultSize(width: 650, height: 400)
    }
}
