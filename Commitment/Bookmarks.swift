//
//  Bookmarks.swift
//  Commitment
//
//  Created by Stef Kors on 26/02/2023.
//

import Foundation

//
//  Bookmarks.swift
//  GetFolderAccessMacOS
//
//  Created by Siddhesh Mhatre on 21/12/17.
//  Copyright © 2017 Siddhesh Mhatre. All rights reserved.
//
import Foundation
import SwiftUI

class GitCredentialsOpenPanel: NSObject, NSOpenSavePanelDelegate {
    func panel(_: Any, shouldEnable url: URL) -> Bool {
        return url.lastPathComponent == ".git-credentials"
    }
}

class SSHKeyOpenPanel: NSObject, NSOpenSavePanelDelegate {
    func panel(_: Any, shouldEnable url: URL) -> Bool {
        return url.lastPathComponent == ".pub"
    }
}

class Bookmarks {
    var bookmarks = [URL: Data]()
    func openFolderSelection() -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.begin { (result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                let url = openPanel.url
                self.storeFolderInBookmark(url: url!)
            }
        }
        return openPanel.url
    }

    func openGitConfig() -> URL? {
        let openPanel = NSOpenPanel()
        let delegate = GitCredentialsOpenPanel()
        openPanel.delegate = delegate
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        openPanel.title = "Select your .git-credentials file"
        openPanel.resolvesAliases = true
        openPanel.showsHiddenFiles = true
        openPanel.directoryURL = URL(filePath: "~/")

        let response = openPanel.runModal()
        if response == .OK {
            if let url = openPanel.url {
                self.storeFolderInBookmark(url: url)
                return url
            }
        }

        return nil
    }

    func openSSHKey() -> URL? {
        let openPanel = NSOpenPanel()
        let delegate = SSHKeyOpenPanel()
        openPanel.delegate = delegate
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        openPanel.title = "Select your ssh.pub key"
        openPanel.resolvesAliases = true
        openPanel.showsHiddenFiles = true
        openPanel.directoryURL = URL(filePath: "~/.ssh/")

        let response = openPanel.runModal()
        if response == .OK {
            if let url = openPanel.url {
                self.storeFolderInBookmark(url: url)
                return url
            }
        }

        return nil
    }

    func saveBookmarksData() throws {
        let path = getBookmarkPath()
        let data = try NSKeyedArchiver.archivedData(withRootObject: bookmarks, requiringSecureCoding: false)
        try data.write(to: path)
        // NSKeyedArchiver.archiveRootObject(bookmarks, toFile: path)
    }

    func storeFolderInBookmark(url: URL) {
        do {
            let data = try url.bookmarkData(options: NSURL.BookmarkCreationOptions.withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            bookmarks[url] = data
            try self.saveBookmarksData()
        } catch {
            Swift.print ("Error storing bookmarks")
        }
    }

    func getBookmarkPath() -> URL {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        url = url.appendingPathComponent("Bookmarks.dict")
        return url
    }

    func loadBookmarks() {
        let path = getBookmarkPath().path
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [URL: Data] {
            bookmarks = data
            for bookmark in bookmarks {
                restoreBookmark(bookmark)
            }
        }
    }

    func restoreBookmark(_ bookmark: (key: URL, value: Data)) {
        let restoredUrl: URL?
        var isStale = false
        Swift.print ("Restoring \(bookmark.key)")
        do {
            restoredUrl = try URL.init(resolvingBookmarkData: bookmark.value, options: NSURL.BookmarkResolutionOptions.withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
        } catch {
            Swift.print ("Error restoring bookmarks")
            restoredUrl = nil
        }
        if let url = restoredUrl {
            if isStale {
                Swift.print ("URL is stale (\(url.description))")
            } else {
                if !url.startAccessingSecurityScopedResource() {
                    Swift.print ("Couldn't access: \(url.path)")
                }
            }
        }
    }

}
