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
import WindowManagement

//class CommitmentDocumentController: NSDocumentController {
//
//    override func openDocument(withContentsOf url: URL, display displayDocument: Bool) async throws -> (NSDocument, Bool) {
//        print("url: \(url.description)")
//        return (NSDocument(), true)
//    }
//}


// TODO: implement dock icon right click menu

class CommitmentAppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
//    let documentController = CommitmentDocumentController()

    private var repos: [CodeRepository] = []
    private lazy var container: ModelContainer? = {
        //let configuration = ModelConfiguration(inMemory: true)
        let container = try? ModelContainer(for: CodeRepository.self, Bookmark.self, GitFileStatus.self)
        return container
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        fetchRepositories()
    }

    func applicationDidBecomeActive(_ notification: Notification) { }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        return true
    }

    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        let menu = NSMenu()
        menu.addItem(.separator())
        return menu
    }

    @objc
    func handleMenu(_ sender: NSMenuItem) {
        guard let path: URL = sender.representedObject as? URL else { return }
        NSApp.openWindow(.mainWindow, value: path)
        print("dock menu action!")
    }

    @MainActor private func fetchRepositories() {
        guard let context = container?.mainContext else { return }
        let fetchDescriptor: FetchDescriptor<CodeRepository> = FetchDescriptor()
        do {
            self.repos = try context.fetch(fetchDescriptor)
        } catch {
            print(error)
        }
    }
}
