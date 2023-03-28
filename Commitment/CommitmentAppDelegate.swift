//
//  CommitmentAppDelegate.swift
//  Commitment
//
//  Created by Stef Kors on 27/03/2023.
//

import Foundation
import AppKit

class CommitmentAppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    func application(
        _ application: NSApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // Record the device token.
    }
}


// ARF not working!
class CommitmentDockTilePlugIn: NSObject, NSDockTilePlugIn {
    func setDockTile(_ dockTile: NSDockTile?) {
        //
        print("setDockTile has:\(dockTile != nil)")
    }

    func dockMenu() -> NSMenu? {
        print("dockMenu")
        let menu = NSMenu()
        menu.insertItem(NSMenuItem(title: "test menu item", action: nil, keyEquivalent: ""), at: 0)
        return menu
    }
}
