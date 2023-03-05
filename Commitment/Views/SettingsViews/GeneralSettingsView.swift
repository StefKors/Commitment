//
//  GeneralSettingsView.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI
import Boutique

struct GeneralSettingsView: View {
    @EnvironmentObject var appModel: AppModel
    @AppStorage("SelectedExternalGitProvider") private var selectedExternalGitProvider: String = "GitHub"

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
        GroupBox(content: {
            VStack {
                HStack {
                    Text("External Editor")
                    Spacer()
                    
                    Picker("Editor Picker", selection: appModel.$editor.binding) {
                        ForEach(externalEditorPickerItems, id: \.name) { item in
                            Text(item.name).tag(item)
                        }
                    }
                    .labelsHidden()
                    .frame(maxWidth: 150)
                }

                Divider()

                HStack {
                    Text("External Git Provider")
                    Spacer()
                    Picker("Git Provider", selection: $selectedExternalGitProvider) {
                        ForEach(externalGitProviderPickerItems, id: \.self) { item in
                            Text(item).tag(item as String?)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .frame(maxWidth: 80)
                }
            }.padding(6)
        }, label: {
            // Text("Credentials")
            VStack(alignment: .leading) {
                Text("Editor Defaults")
                    .labelStyle(.titleOnly)
                    .font(.title3)
                    .fontWeight(.semibold)

                Text("Choose your default code editor")
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 6)
        })
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}
