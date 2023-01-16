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
        "sourcehut",
        "Radicle",
    ]

    var body: some View {
        Form {
            Picker(selection: $selectedExternalEditor, label: Text("External editor:")) {
                ForEach(externalEditorPickerItems, id: \.self) { item in
                    Text(item).tag(item as String?)
                }
            }

            Picker(selection: $selectedExternalGitProvider, label: Text("External Git Provider:")) {
                ForEach(externalGitProviderPickerItems, id: \.self) { item in
                    Text(item).tag(item as String?)
                }
            }
        }
        .padding(20)
        .frame(width: 350, height: 100)
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}
