//
//  GitFolderContentMonitorView.swift
//  Commitment
//
//  Created by Stef Kors on 14/10/2023.
//

import SwiftUI
import OSLog

fileprivate let log = Logger(subsystem: "com.stefkors.commitment", category: "GitFileMonitor")

struct GitFolderContentMonitorView: ViewModifier {
    @State private var folderMonitor: FolderContentMonitor

    init(url: URL, onFileChange: ( (FolderContentChangeEvent) -> Void)? = nil, onGitChange: ( (FolderContentChangeEvent) -> Void)? = nil) {
        self.folderMonitor = FolderContentMonitor(url: url, latency: 1, callback: { event in
            // TODO: Figure out better filtering... Perhaps based on .gitignore?
            // skip lock events
            if event.filename == "index.lock", event.filename == ".DS_Store" {
                return
            }

            let isGitFolderChange = event.eventPath.contains("/.git/")
            log.debug("[File Change][\(url.lastPathComponent)] \(event.url.lastPathComponent)")

            if isGitFolderChange, event.filename == "HEAD" {
                onGitChange?(event)
            }

            if !isGitFolderChange {
                onFileChange?(event)
            }
        })
    }

    func body(content: Content) -> some View {
        content
            .task(id: folderMonitor.pathsToWatch) {
                self.folderMonitor.start()
            }
    }
}

extension View {
    func gitFolderMonitor(url: URL, onFileChange: ( (FolderContentChangeEvent) -> Void)? = nil, onGitChange: ( (FolderContentChangeEvent) -> Void)? = nil) -> some View {
        modifier(GitFolderContentMonitorView(url: url, onFileChange: onFileChange, onGitChange: onGitChange))
    }

    func gitFolderMonitor(_ url: URL, onFileChange: ( (FolderContentChangeEvent) -> Void)? = nil, onGitChange: ( (FolderContentChangeEvent) -> Void)? = nil) -> some View {
        modifier(GitFolderContentMonitorView(url: url, onFileChange: onFileChange, onGitChange: onGitChange))
    }
}

#Preview {
    Text("Hello, world!")
        .gitFolderMonitor(.previewFolder) { change in
            print("file change")
        } onGitChange: { change in
            print("git change")
        }
}

