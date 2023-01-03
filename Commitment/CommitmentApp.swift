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
                    // NSApp.mainWindow?.styleMask.remove(.titled)
                    NSApp.mainWindow?.standardWindowButton(.zoomButton)?.isHidden = true
                    NSApp.mainWindow?.standardWindowButton(.closeButton)?.isHidden = true
                    NSApp.mainWindow?.standardWindowButton(.miniaturizeButton)?.isHidden = true
                    NSApp.mainWindow?.toolbar = nil
                })
                .frame(minWidth: 100, idealWidth: 200, maxWidth: 600,
                       minHeight: 30, idealHeight: 30, maxHeight: 90,
                       alignment: .center)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
