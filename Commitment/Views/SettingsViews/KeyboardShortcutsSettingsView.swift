//
//  KeyboardShortcutsSettingsView.swift
//  Commitment
//
//  Created by Stef Kors on 05/05/2023.
//

import SwiftUI
import KeyboardShortcuts

struct KeyboardShortcutsSettingsView: View {
    var body: some View {
        SettingsBox(
            label: "Keyboard Shortcuts"
        ) {
            KeyboardShortcuts.Recorder("Toggle Global Commit Window:", name: .globalCommitPanel)
        }
    }
}

struct KeyboardShortcutsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardShortcutsSettingsView()
    }
}
