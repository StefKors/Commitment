//
//  CommitmentAppDelegate.swift
//  Commitment
//
//  Created by Stef Kors on 27/03/2023.
//

import Foundation
import AppKit
import SwiftData
import SwiftUI

// TODO: implement dock icon right click menu

class CommitmentAppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    private var repos: [CodeRepository] = []

    lazy var container: ModelContainer = {
        //let configuration = ModelConfiguration(inMemory: true)
        let container = try! ModelContainer(for: CodeRepository.self, Bookmark.self)
        return container
    }()

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
        fetchRepositories()
//        NSApp.activate(ignoringOtherApps: true)
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
//        print("dock menu?")
        fetchRepositories()
        let menu = NSMenu()
        for repo in repos {
            let menuItem = NSMenuItem(title: repo.folderName, action: #selector(handleMenu), keyEquivalent: "")
            menuItem.representedObject = repo.path
            menuItem.image = NSWorkspace.shared.icon(forFile: repo.path.path(percentEncoded: false))
            menuItem.image?.size = NSSize(width: 13, height: 13)
            menu.insertItem(menuItem, at: 0)
        }
        return menu
    }

    @objc
    func handleMenu(_ sender: NSMenuItem) {
        guard let path: URL = sender.representedObject as? URL else { return }
        NSApp.openWindow(.mainWindow, value: path)
        print("dock menu action!")
    }

    @MainActor private func fetchRepositories() {
        let context = container.mainContext

        let fetchDescriptor: FetchDescriptor<CodeRepository> = FetchDescriptor()

        do {
            self.repos = try context.fetch(fetchDescriptor)
        } catch {
            print(error)
        }
    }
}
