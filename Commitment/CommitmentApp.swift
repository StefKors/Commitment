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
import UniformTypeIdentifiers

// https://github.com/Wouter01/SwiftUI-WindowManagement
// NSWindow.alwaysUseActiveAppearance = true
/// theming?
// /.foregroundStyle(.blue, .green, Gradient(colors: [.red, .yellow]))
// /.backgroundStyle(.pink)
// https://developer.apple.com/documentation/foundation/filemanager/2765464-enumerator

extension SceneID {
    static let mainWindow = SceneID("MainWindow")
}

// TODO: onboarding
// CLI tool for controlling the app
// https://www.youtube.com/watch?v=hPEDjbb_BD0
@main
struct CommitmentApp: App {
    @NSApplicationDelegateAdaptor private var appDelegate: CommitmentAppDelegate
    @Environment(\.dismissWindow) private var dismissWindow
    // TODO: How to handle shell?

    init() {
        NSWindow.alwaysUseActiveAppearance = true
    }

    // SwiftData types
    let container = try! ModelContainer(for: CodeRepository.self, Bookmark.self, GitFileStatus.self, GitDiff.self)

    var body: some Scene {
        WindowGroup(id: SceneID.mainWindow.id, for: URL.self) { $repositoryID in
            ContentView(repositoryID: $repositoryID)
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
