//
//  GeneralSettingsView.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI
import Boutique

enum DiffViewMode: String, CaseIterable {
    case unified = "Unified"
    case sideBySide = "Side by Side"
}

struct GeneralSettingsView: View {
    @EnvironmentObject var appModel: AppModel
    @AppStorage("SelectedExternalGitProvider") private var selectedExternalGitProvider: String = "GitHub"
    @AppStorage("DiffSettings.ViewMode") private var diffViewMode: DiffViewMode = .unified
    @AppStorage("SideBySideView") private var sideBySide: Bool = false

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
            Picker("External Editor", selection: appModel.$editor.binding) {
                ForEach(externalEditorPickerItems, id: \.name) { item in
                    Text(item.name).tag(item)
                }
            }

            Picker("External Git Provider", selection: $selectedExternalGitProvider) {
                ForEach(externalGitProviderPickerItems, id: \.self) { item in
                    Text(item).tag(item as String?)
                }
            }
        }

        if sideBySide {
            SettingsBox(
                label: "Diff Settings"
            ) {
                Picker("View Mode", selection: $diffViewMode) {
                    ForEach(DiffViewMode.allCases, id: \.self) { item in
                        Text(item.rawValue).tag(item.rawValue)
                    }
                }.pickerStyle(.segmented)
            }
        }
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}
