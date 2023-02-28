//
//  GeneralSettingsView.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage("SelectedExternalEditor") private var selectedExternalEditor: String = "Visual Studio Code"
    @AppStorage("SelectedExternalGitProvider") private var selectedExternalGitProvider: String = "GitHub"

    private let externalEditorPickerItems = [
        "Visual Studio Code",
        "WebStorm",
        "Xcode",
    ]

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

                    Picker(selection: $selectedExternalEditor) {
                        ForEach(externalEditorPickerItems, id: \.self) { item in
                            Text(item)
                                .tag(item as String?)
                        }
                    } label: { }
                        .pickerStyle(.menu)
                        .frame(maxWidth: 120)
                }

                Divider()

                HStack {
                    Text("External Git Provider")
                    Spacer()
                    Picker(selection: $selectedExternalGitProvider) {
                        ForEach(externalGitProviderPickerItems, id: \.self) { item in
                            Text(item).tag(item as String?)
                        }
                    } label: { }
                        .pickerStyle(.menu)
                        .frame(maxWidth: 120)
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
