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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .ignoresSafeArea()
                .environmentObject(git)
                .presentedWindowStyle(.hiddenTitleBar)
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification), perform: { _ in
                    NSApp.mainWindow?.standardWindowButton(.zoomButton)?.isHidden = true
                    NSApp.mainWindow?.standardWindowButton(.closeButton)?.isHidden = true
                    NSApp.mainWindow?.standardWindowButton(.miniaturizeButton)?.isHidden = true
                    NSApp.mainWindow?.toolbar = nil
                })
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
