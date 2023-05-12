//
//  CredentialSettingsView.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI
import KeychainAccess

struct SSHKeys: Codable {
    var values: [SSHKey]
}

struct SSHKey: Codable, Identifiable, Equatable, Hashable {
    var id: String {
        self.url.absoluteString
    }
    let url: URL
    var name: String {
        self.url.lastPathComponent
    }
    var key: String
}

struct SSHKeyView: View {
    let item: SSHKey
    @Binding var passwords: SSHKeys?
    @State private var showDelete: Bool = false
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(item.name)
                        .foregroundColor(.primary)
                    Text(item.key)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            if showDelete {
                Button(role: .destructive) {
                    withAnimation(.easeOut(duration: 0.2)) {
                        passwords?.values.removeAll { credential in
                            credential == item
                        }
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .tint(.red)
                .buttonStyle(.borderedProminent)
            } else {
                Image(systemName: "info.circle")
                    .imageScale(.large)
                    .onTapGesture {
                        withAnimation(.stiffBounce) {
                            showDelete = true
                        }
                    }
            }
        }
    }
}

struct SSHKeysSettingsView: View {
    @EnvironmentObject private var model: AppModel
    @KeychainStorage("sshkeys") private var keys: SSHKeys? = nil
    
    var body: some View {
        SettingsBox(label: "SSH Keys") {
            Text(try! AttributedString(markdown: "Import your `ssh` keys to authenticate with external Git Services. Click import to get started."))
            if let keys {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(keys.values) { key in
                        SSHKeyView(item: key, passwords: $keys)
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
        }
    }
    
    /// Use NSOpenPanel to open the users git config and update the stored credentials.
    func handleImportAction() {
        if let path = model.bookmarks.openSSHKey() {
            if let content = try? String(contentsOf: URL(filePath: path.path()), encoding: .utf8) {
                let oldValues = keys?.values ?? []
                let newValues = oldValues + [SSHKey(url: path, key: content)]
                withAnimation(.easeOut(duration: 0.2)) {
                    keys = SSHKeys(values: newValues)
                }
            }
        } else {
            print("failed to get path")
        }
    }
}

struct AdvancedSettingsView_Previews: PreviewProvider {
    // Credentials(values: [
    //     Credential(url: URL(string:"https://stefstefstef:sdflkjsdfJstaRpyj3sdlkjdsflkjsdf8D@github.com")!),
    //     Credential(url: URL(string:"https://nemo:ghsdflkjsdfkJstaRpsdflkjfjdsflkjsdf8D@bitbucket.com")!),
    //     Credential(url: URL(string:"https://sigfault:glkjsdfljtaRpsdflkjfjdsflkjsdf8D@gitlab.com")!),
    // ])
    static var previews: some View {
        CredentialSettingsView()
            .frame(maxWidth: 450)
            .scenePadding()
    }
}
