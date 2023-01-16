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
}

extension URL {
    var isDirectory: Bool {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}
