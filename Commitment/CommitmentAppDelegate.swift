//
//  CommitmentAppDelegate.swift
//  Commitment
//
//  Created by Stef Kors on 27/03/2023.
//

import Foundation
import AppKit

// TODO: implement dock icon right click menu

class CommitmentAppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    func application(
        _ application: NSApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // Record the device token.
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // NSApp.dockTile.display()
//        print("dock?1")
        // NSApp.dockTile = DockTilePlugin()
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        // activateTheRealFinder()
//        print("dock?2 \(NSDocumentController.shared.recentDocumentURLs)")

    }

    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        print("tried to openFile from ?dock? \(filename)")
        return true
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // openTheRealFinder()
//        print("dock?3 ")
        return true
    }

    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        print("dock menu?")
        let menu = NSMenu()
        menu.insertItem(NSMenuItem(title: "test menu item", action: #selector(handleMenu), keyEquivalent: ""), at: 0)
        return menu
    }

    @objc
    func handleMenu() {
        print("dock menu action!")
    }
}
