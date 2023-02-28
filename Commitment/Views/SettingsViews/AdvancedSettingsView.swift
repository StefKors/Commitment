//
//  AdvancedSettingsView.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI
import KeychainAccess
// appModel.bookmarks.openGitConfig()

struct Credentials: Codable {
    let values: [Credential]
}
struct Credential: Codable, Identifiable, Equatable {
    var id: String {
        self.name
    }
    let name: String
    let value: String
}

struct SettingsBox<Content: View, Label: View>: View {
    let ContainerContent: Content
    let ContainerLabel: Label
    
    /// Creates a SettingsBox with custom content and label.
    init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) {
        self.ContainerContent = content()
        self.ContainerLabel = label()
    }
    
    var body: some View {
        GroupBox() {
            HStack(alignment: .top) {
                ContainerLabel
                ContainerContent
            }
        }
    }
}

struct CredentialView: View {
    let item: Credential
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                Text(String(repeating: "⏺", count: item.value.count))
            }
            Spacer()
            Image(systemName: "info.circle")
                .imageScale(.large)
        }
    }
}

struct AdvancedSettingsView: View {
    @AppStorage("isOn") var isOn = true
    
    // @KeychainStorage("passwords")
    var passwords = Credentials(values: [
        Credential(name: "GitHub", value: "skldjsfsdlkfdsljk"),
        Credential(name: "GitLab", value: "skldjsfsdlkfdsljk"),
        Credential(name: "SourceHut", value: "skldjsfsdlkfdsljk")
    ])
    
    var body: some View {
        GroupBox(content: {
            VStack {
                if let passwords {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(passwords.values) { credential in
                            CredentialView(item: credential)
                            Divider()
                        }
                    }
                    .frame(alignment: .leading)
                }
                HStack {
                    Spacer()
                    Button("Import", action: handleImportAction)
                }
                .frame(alignment: .trailing)
            }.padding(6)
        }, label: {
            // Text("Credentials")
            VStack(alignment: .leading) {
                Text("Credentials")
                    .labelStyle(.titleOnly)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("Your git credentials can be parsed and imported from an .git-credentials file. Click import to get started.")
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 6)
        })
    }
    
    func handleImportAction() {
        print("")
    }
}

struct AdvancedSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSettingsView()
            .frame(maxWidth: 450)
    }
}
