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
        Form {
            KeyboardShortcuts.Recorder("Toggle Unicorn Mode:", name: .toggleUnicornMode)
        }
        .formStyle(.grouped)
    }
}

struct KeyboardShortcutsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardShortcutsSettingsView()
    }
}
