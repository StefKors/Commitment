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
import HotKey


// https://github.com/Wouter01/SwiftUI-WindowManagement
// NSWindow.alwaysUseActiveAppearance = true
/// theming?
// /.foregroundStyle(.blue, .green, Gradient(colors: [.red, .yellow]))
// /.backgroundStyle(.pink)


// CLI tool for controlling the app
// https://www.youtube.com/watch?v=hPEDjbb_BD0
@main
struct CommitmentApp: App {
    @AppStorage("CommitWindow") private var commitWindow: Bool = false
    @NSApplicationDelegateAdaptor private var appDelegate: CommitmentAppDelegate
    @StateObject var appModel: AppModel = .shared
    @StateObject var activity = ActivityState()
    // @State private var repo: RepoState? = nil
    @Environment(\.window) private var window
    // @State private var selectedRepo: RepoState.ID? = nil

    init() {
        NSWindow.alwaysUseActiveAppearance = true
    }

    var body: some Scene {
        Window("Commitment", id: "MainWindow", content: {
            ZStack {
                if let repo = appModel.activeRepo {
                    RepoWindow()
                        // .ignoresSafeArea(.all, edges: .top)
                        .environmentObject(repo)
                        .environmentObject(repo.undo)
                        // .focusedSceneValue(\.repo, repo)
                        .buttonStyle(.regularButtonStyle)
                        .task(id: repo.id) {
                            repo.startMonitor()
                            Task {
                                do {
                                    try await repo.refreshRepoState()
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                } else {
                    WelcomeSheet()
                }
            }
            .environmentObject(appModel)
            .environmentObject(activity)
            // .onReceive(appModel.activeRepositoryId.publisher, perform: { newVal in
            //     let repo = appModel.repos.first(with: appModel.activeRepositoryId) ?? appModel.repos.first
            //     guard let repo else { return }
            //     self.repo = repo
            //     Task {
            //         do {
            //             try await self.repo?.refreshRepoState()
            //         } catch {
            //             print(error.localizedDescription)
            //         }
            //     }
            //     self.repo?.startMonitor()
            // })
        })
        .register("MainWindow")
        .titlebarAppearsTransparent(true)
        .windowToolbarStyle(.unifiedCompact(showsTitle: false))
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentMinSize)
        .commands {
            SidebarCommands()
            AppCommands(repo: appModel.activeRepo, appModel: appModel)
            OverrideCommands()
            TextEditingCommands()
        }

        Window("Settings", id: "settings") {
            SettingsWindow()
                .frame(width: 650, height: 400)
                .environmentObject(appModel)
                .hideSidebarToggle()
        }
        .windowStyle(.automatic)
        .windowToolbarStyle(.unified)
        .windowResizability(.contentSize)
        .defaultSize(width: 650, height: 400)
    }
}
