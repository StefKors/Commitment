//
//  URL.swift
//  Commitment
//
//  Created by Stef Kors on 16/01/2023.
//

import Foundation
import AppKit

extension URL {
    func showInFinder() {
        if self.isDirectory {
            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: self.path)
        } else {
            NSWorkspace.shared.activateFileViewerSelecting([self])
        }
    }

    func openInEditor(_ editor: ExternalEditor) {
        let appUrl = editor.bundleIdentifiers.compactMap { identifier in
            NSWorkspace.shared.urlForApplication(withBundleIdentifier: identifier)
        }.first

        if let appUrl {
            let config = NSWorkspace.OpenConfiguration.init()
            config.promptsUserIfNeeded = true
            config.activates = true
            NSWorkspace.shared.open([self], withApplicationAt: appUrl, configuration: config)
        }
    }
}

extension URL {
    var isDirectory: Bool {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}
