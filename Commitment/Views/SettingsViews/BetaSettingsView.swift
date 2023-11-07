//
//  BetaSettingsView.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI

struct BetaSettingsView: View {
    @AppStorage(Settings.Diff.Mode) private var diffViewMode: DiffViewMode = .unified

    var body: some View {
        SettingsBox(
            label: "Feature Flags"
        ) {
            Text("Below is a list of feature flags that enable / disable features that are still experimental. Use at your own risk.")
            Picker("Diff View Style", selection: $diffViewMode) {
                Image(systemName: "rectangle.split.2x1.fill").tag(DiffViewMode.sideBySide)
                Image(systemName: "rectangle.split.1x2.fill").tag(DiffViewMode.unified)
            }
            .pickerStyle(.segmented)
        }
    }
}

struct BetaSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        BetaSettingsView()
    }
}
