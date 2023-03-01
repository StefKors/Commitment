//
//  CommitmentApp.swift
//  Commitment
//
//  Created by Stef Kors on 06/04/2022.
//

import SwiftUI
import Boutique
import Foundation

/// theming?
// /.foregroundStyle(.blue, .green, Gradient(colors: [.red, .yellow]))
// /.backgroundStyle(.pink)



// https://reichel.dev/blog/swift-global-key-binding.html#install-hotkey
@main
struct CommitmentApp: App {
    @StateObject var appModel: AppModel = .shared
    @State private var repo: RepoState?

    var body: some Scene {
        Window("Commitment", id: "main window", content: {
            Group {
                if appModel.repos.isEmpty {
                    // Appicon view is slow?
                    // repos list is slow?
                    WelcomeWindow()
                        .frame(minWidth: 400, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
                    // .navigationTitle("Commitment")
                } else if let repo {
                    RepoWindow()
                        .environmentObject(repo)
                } else {
                    EmptyView()
                }
            }
            .environmentObject(appModel)
            .onReceive(appModel.activeRepositoryId.publisher, perform: { newVal in
                let repo = appModel.repos.first(with: appModel.activeRepositoryId) ?? appModel.repos.first
                guard let repo else { return }

                self.repo = repo
                repo.refreshBranch()
                Task {
                    try? await repo.refreshDiffsAndStatus()
                }
                repo.startMonitor()
            })
            .task {
                 FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
                // Bundle.main.resourcePath
            }

        })
        // .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact(showsTitle: true))
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
