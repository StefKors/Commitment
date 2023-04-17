//
//  RepoState+Commands.swift
//  Commitment
//
//  Created by Stef Kors on 12/04/2023.
//

import SwiftUI

extension FocusedValues {
    struct RepoFocusedValues: FocusedValueKey {
        typealias Value = Binding<RepoState?>
    }

    var repo: Binding<RepoState?>? {
        get {
            self[RepoFocusedValues.self]
        }
        set {
            self[RepoFocusedValues.self] = newValue
        }
    }
}


extension RepoState {
    /// Creates a "Discard Change" stash so we have an do/undo trail
    func discardActiveChange() async {
        if let selectedChange = self.view.activeChangesSelection?.split(separator: " -> ").first {
            let path = String(selectedChange)
            // git stash push --include-untracked -m "Discard Change" Commitment/State/Fileagain.swift
            var message = "Discard Change"

            let fileName = URL(filePath: path).lastPathComponent
            if !fileName.isEmpty {
                message = "Discard Change to \(fileName)"
            }
            let commands = ["stash", "push", "--include-untracked", "-m", message, path]
            _ = try? await shell.run(.git, commands)

            withAnimation(.stiffBounce) {
                let action = UndoAction(type: .stash, arguments: commands)
                self.undo.stack.append(action)
            }
        }
    }

    func discardAllChanges() async {
        // _ = try? await shell.run(.git, ["restore", "."])
    }
}
