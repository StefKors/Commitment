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
@main
struct CommitmentApp: App {
    @NSApplicationDelegateAdaptor private var appDelegate: CommitmentAppDelegate
    @StateObject var appModel: AppModel = .shared
    @State private var repo: RepoState? = nil
    @Environment(\.window) private var window

    @State private var selectedRepo: RepoState.ID? = nil

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
                        .environmentObject(repo.undo)
                        // .focusedSceneValue(\.repo, $repo)
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
            AppCommands()
        }

        WindowGroup("Commit", id: "CommitWindow", for: RepoState.ID.self) { $repoID in
            let id = "file:///Users/stefkors/Developer/Commitment"
            ZStack {
                // Rectangle().fill(.regularMaterial)
                GroupBox {
                    ZStack {
                        Rectangle().fill(.clear)
                        CommitHotKeyWindow(id: id)
                            .environmentObject(appModel)
                    }
                    // .scenePadding(.top)
                }
                .scrollIndicators(.hidden)
                .groupBoxStyle(HotKeyAccentBorderGroupBoxStyle())
                .padding(12)
            }
            .safeAreaInset(edge: .top, content: {
                HStack {
                    ForEach(appModel.repos.sorted(by: { repoA, repoB in
                        // todo: improve this mess
                        if let dateA = repoA.lastUpdate, let dateB = repoB.lastUpdate {
                            return dateA > dateB
                        }

                        return false
                    }).suffix(5), id: \.id) { repo in
                        if repo.id == appModel.activeRepositoryId {
                            Button(repo.folderName) {
                                appModel.$activeRepositoryId.set(repo.id)
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(0)
                        } else {
                            Button(repo.folderName) {
                                appModel.$activeRepositoryId.set(repo.id)
                            }
                            .buttonStyle(.bordered)
                            .padding(0)
                        }
                    }
                }
                .padding(0)
                .scenePadding(.top)
            })
            .background(.regularMaterial, ignoresSafeAreaEdges: .top)
            .edgesIgnoringSafeArea(.top)
            // .frame(width: 1000, height: 600)
        }
        .register("CommitWindow")
        .titlebarAppearsTransparent(true)
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 1000, height: 600)
        .windowResizability(.contentSize)
        // .windowResizability(.contentMinSize)
        .windowButton(.miniaturizeButton, hidden: true)
        .windowButton(.zoomButton, hidden: true)
        .windowButton(.closeButton, hidden: true)
        .backgroundColor(.clear)
        .movableByBackground(true)
        // .movable(false)
        .defaultPosition(.center)


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
