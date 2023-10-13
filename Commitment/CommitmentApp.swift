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
import SwiftData

// https://github.com/Wouter01/SwiftUI-WindowManagement
// NSWindow.alwaysUseActiveAppearance = true
/// theming?
// /.foregroundStyle(.blue, .green, Gradient(colors: [.red, .yellow]))
// /.backgroundStyle(.pink)

extension SceneID {
    static let mainWindow = SceneID("MainWindow")
    static let welcomeWindow = SceneID("WelcomeWindow")
}


// CLI tool for controlling the app
// https://www.youtube.com/watch?v=hPEDjbb_BD0
@main
struct CommitmentApp: App {
    @NSApplicationDelegateAdaptor private var appDelegate: CommitmentAppDelegate
    // TODO: How to handle shell?

    init() {
//        enableWindowSizeSaveOnQuit(true)
        NSWindow.alwaysUseActiveAppearance = true
    }

    // SwiftData types
    let container = try! ModelContainer(for: CodeRepository.self, Bookmark.self)
    // TODO: onboarding
    var body: some Scene {
        Window("Welcome", id: SceneID.welcomeWindow.id) {
            WelcomeContentView()
                .frame(width: 700, height: 300, alignment: .center)
        }
        .windowResizability(.contentSize)
        .register(.welcomeWindow)

        .transition(.none)
        .defaultSize(width: 700, height: 300)
        .enableOpenWindow()
        .titlebarAppearsTransparent(true)
        .windowToolbarStyle(.unifiedCompact(showsTitle: false))
        .windowStyle(.hiddenTitleBar)
        .modelContainer(container)

        WindowGroup(id: SceneID.mainWindow.id, for: URL.self) { $repositoryID in
            // TODO: better way to handle this?
            if let repositoryID {
                RepositoryWindow(path: repositoryID)
                    .frame(minWidth: 1000)

            } else {
                EmptyView()
            }
        }
        .modelContainer(container)
        .register(.mainWindow)
        .enableOpenWindow()
        .titlebarAppearsTransparent(true)
        .windowToolbarStyle(.unifiedCompact(showsTitle: false))
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentMinSize)
        .commands {
            SidebarCommands()
            //            AppCommands(repo: appModel.activeRepo, appModel: appModel)
            //            OverrideCommands()
            TextEditingCommands()
        }
////
//
//        Window("Welcome", id: "WelcomeWindow") {
//            WelcomeContentView()
//        }
//        .modelContainer(container)


//        Window("Settings", id: "settings") {
//            SettingsWindow()
//                .frame(width: 650, height: 400)
//                .hideSidebarToggle()
//        }
//        .windowStyle(.automatic)
//        .windowToolbarStyle(.unified)
//        .windowResizability(.contentSize)
//        .defaultSize(width: 650, height: 400)
    }
}
