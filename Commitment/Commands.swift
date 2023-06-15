//
//  Commands.swift
//  Commitment
//
//  Created by Stef Kors on 12/04/2023.
//

import SwiftUI

struct AppCommands: Commands {
    // From: https://nilcoalescing.com/blog/ProvidingTheCurrentDocumentToMenuComma...
    let repo: RepoState?
    let appModel: AppModel

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
                    Task {
                        do {
                            try await appModel.removeRepo(repo: repo)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }) {
                    Text ("Remove...")
                }
            }
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
