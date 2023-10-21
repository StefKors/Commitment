//
//  GeneralSettingsView.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI
import Boutique

struct GeneralSettingsView: View {
    @AppStorage(Settings.Git.Provider) private var selectedExternalGitProvider: String = "GitHub"
    @AppStorage(Settings.Diff.Mode) private var diffViewMode: DiffViewMode = .unified
    @AppStorage(Settings.Diff.ShowStatsBlocks) private var showStatsBlocks: Bool = true
    @AppStorage(Settings.Editor.ExternalEditor) private var externalEditor: ExternalEditor = ExternalEditor.xcode

    private var externalEditorPickerItems: [ExternalEditor] {
        ExternalEditors().editors.filter { editor in
            editor.bundleIdentifiers.first { identifier in
                NSWorkspace.shared.urlForApplication(withBundleIdentifier: identifier) != nil
            } != nil
        }
    }

    private let externalGitProviderPickerItems = [
        "GitHub",
        "GitLab",
        "Bitbucket",
        "SourceHut",
        "Radicle",
    ]

    var body: some View {
        SettingsBox(
            label: "Editor Defaults"
        ) {
            Picker("External Editor", selection: $externalEditor) {
                ForEach(externalEditorPickerItems, id: \.self) { item in
                    Text(item.name).tag(item)
                }
            }

            Picker("External Git Provider", selection: $selectedExternalGitProvider) {
                ForEach(externalGitProviderPickerItems, id: \.self) { item in
                    Text(item).tag(item as String?)
                }
            }
        }

        SettingsBox(
            label: "Diff Settings"
        ) {
            Picker("View Mode", selection: $diffViewMode) {
                ForEach(DiffViewMode.allCases, id: \.self) { item in
                    Text(item.rawValue).tag(item.rawValue)
                }
            }.pickerStyle(.segmented)

            Toggle("Show Blocks in Diff stats", isOn: $showStatsBlocks)
                .toggleStyle(.switch)
        }
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}
