//
//  FolderContentMonitorView.swift
//  Commitment
//
//  Created by Stef Kors on 14/10/2023.
//

import SwiftUI

struct FolderContentMonitorView: ViewModifier {
    @State private var folderMonitor: FolderContentMonitor

    init(url: URL, callback: ( (FolderContentChangeEvent) -> Void)? = nil) {
        self.folderMonitor = FolderContentMonitor(url: url, latency: 1, callback: callback)
    }

    func body(content: Content) -> some View {
        content
            .task {
                self.folderMonitor.start()
            }
    }
}

extension View {
    func folderMonitor(_ url: URL, callback: ( (FolderContentChangeEvent) -> Void)? = nil) -> some View {
        modifier(FolderContentMonitorView(url: url, callback: callback))
    }
}

#Preview {
    Text("Hello, world!")
        .folderMonitor(.previewFolder) { change in
            print("update")
        }
}
