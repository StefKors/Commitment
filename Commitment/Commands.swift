//
//  Commands.swift
//  Commitment
//
//  Created by Stef Kors on 12/04/2023.
//

import SwiftUI
import SwiftData

struct AppCommands: Commands {
    @Environment(\.modelContext) private var modelContext

    // From: https://nilcoalescing.com/blog/ProvidingTheCurrentDocumentToMenuComma...
    let repo: CodeRepository?

    @CommandsBuilder var body: some Commands {
        if let repo {
            CommandMenu ("Active Changes") {
                Button(action: {
                    Task {
                        await repo.discardActiveChange()
                    }
                }) {
                    Text ("Discard Selected File Changes")
                }
                .keyboardShortcut(.delete)

                Button(action: {
                    Task {
                        await repo.discardAllChanges ()
                    }
                }) {
                    Text ("Discard All Changes")
                }
                .keyboardShortcut(.delete, modifiers: [.command, .shift])
            }
            CommandMenu ("Repository") {
                Button(action: {
                    removeRepo(repo)
                }) {
                    Text ("Remove...")
                }
            }
        }
    }


    private func removeRepo(_ repo: CodeRepository) {
        withAnimation {
            modelContext.delete(repo)
        }
    }
}

struct OverrideCommands: Commands {
    @Environment(\.openWindow) var openWindow

    var body: some Commands {
        CommandGroup(replacing: .appSettings) {
            Button("Settings...") {
                openWindow(id: "settings")
            }
            .keyboardShortcut(",")
        }
    }
}
