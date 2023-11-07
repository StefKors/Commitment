//
//  GeneralSettingsView.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage(Settings.Git.Provider) private var selectedExternalGitProvider: String = "GitHub"
    @AppStorage(Settings.Diff.Mode) private var diffViewMode: DiffViewMode = .unified
    @AppStorage(Settings.Diff.ShowStatsBlocks) private var showStatsBlocks: Bool = true
    // TODO: The external editor picker is not working, crashes when selecting different editor
    @AppStorage(Settings.Editor.ExternalEditor) private var externalEditorSetting: ExternalEditor = ExternalEditors.xcode

    init() {
        externalEditorPickerItems = ExternalEditors().editors
//        ExternalEditors().editors.filter { editor in
//            editor.bundleIdentifiers.first { identifier in
//                NSWorkspace.shared.urlForApplication(withBundleIdentifier: identifier) != nil
//            } != nil
//        }

//        selectedExternalEditor = externalEditorPickerItems.first?.name ?? "Xcode"
    }

//    @State private var externalEditor: ExternalEditor = ExternalEditors.xcode
//    @State private var selectedExternalEditor: String

    private let externalEditorPickerItems: [ExternalEditor]

//    private var externalEditorPickerNames: [String] {
//        externalEditorPickerItems.map { editor in
//            editor.name
//        }
//    }

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
            Picker("External Editor", selection: $externalEditorSetting) {
                ForEach(externalEditorPickerItems, id: \.id) { item in
                    Text(item.name)
                        .tag(item)
                }
            }
            .disabled(true)
//            .task {
//                selectedExternalEditor = externalEditorSetting.name
//            }
            // Update setting
//            .onChange(of: selectedExternalEditor) { oldValue, newValue in
//                print(oldValue, newValue)
//                let editor = externalEditorPickerItems.first(where: { editor in
//                    editor.name == newValue
//                })
//
//                if let editor {
//                    externalEditorSetting = editor
//                }
//            }

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
