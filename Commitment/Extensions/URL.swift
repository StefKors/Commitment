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
        if self.isDirectory {

            let appUrl = editor.bundleIdentifiers.compactMap { identifier in
                NSWorkspace.shared.urlForApplication(withBundleIdentifier: identifier)
            }.first

            if let appUrl {
                let config = NSWorkspace.OpenConfiguration.init()
                config.activates = true
                
                print("open \(self) \(appUrl)")
                NSWorkspace.shared.open([self], withApplicationAt: appUrl, configuration: config)
            }
            // NSWorkspace.shared.urlForApplication(withBundleIdentifier: editor.bundleIdentifiers.fi)
            // NSWorkspace.shared.openFile(self.path(), withApplication: "Microsoft Excel")
        } else {
        }
    }
}

extension URL {
    var isDirectory: Bool {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}
