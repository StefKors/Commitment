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
    func discardActiveChange() async {
        if let selectedChange = self.view.activeChangesSelection?.split(separator: " -> ").first {
            print("selectedChange: \(selectedChange.description)")
            // _ = try? await shell.run(.git, ["restore", String(selectedChange)])
        }
    }

    func discardAllChanges() async {
        // _ = try? await shell.run(.git, ["restore", "."])
    }
}
