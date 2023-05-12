//
//  CredentialSettingsView.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI
import KeychainAccess

struct Credentials: Codable {
    var values: [Credential]
}

struct Credential: Codable, Identifiable, Equatable, Hashable {
    var id: String {
        self.url.absoluteString
    }
    let url: URL
    var password: String {
        self.url.password ?? ""
    }
    var user: String {
        self.url.user ?? ""
    }
    var host: String {
        self.url.host ?? ""
    }
}

struct CredentialView: View {
    let item: Credential
    @Binding var passwords: Credentials?
    @State private var showDelete: Bool = false
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(item.user)
                        .foregroundColor(.primary)
                    Text(item.host)
                        .foregroundColor(.secondary)
                }
                Text(String(repeating: "⏺", count: item.password.count))
                    .lineLimit(1)
                    .truncationMode(.middle)
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

struct CredentialSettingsView: View {
    @EnvironmentObject private var model: AppModel
    @KeychainStorage("passwords") private var passwords: Credentials? = nil
    
    var body: some View {
        SettingsBox(
            label: "Git-Credentials File"
        ) {
            Text(try! AttributedString(markdown: "Your git credentials can be parsed and imported from an `.git-credentials` file. Click import to get started."))
            if let passwords {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(passwords.values) { credential in
                        CredentialView(item: credential, passwords: $passwords)
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
        if let path = model.bookmarks.openGitConfig() {
            if let content = try? String(contentsOf: URL(filePath: path.path()), encoding: .utf8) {
                let oldPasswords = passwords?.values ?? []
                let newPasswords = content
                    .lines
                    .compactMap { line -> Credential? in
                        guard let url = URL(string: String(line)) else { return nil }
                        return Credential(url: url)
                    }
                
                let newValues = Array(Set(oldPasswords + newPasswords))
                writeGitConfig(newValues)
                writeGitCredentials(newValues)
                
                withAnimation(.easeOut(duration: 0.2)) {
                    passwords = Credentials(values: newValues)
                }
            }
        } else {
            print("failed to get path")
        }
    }
    
    fileprivate func writeGitConfig(_ newPasswords: [Credential]) {
        guard let appHome = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: .applicationSupportDirectory, create: true) else { return }
        let toConfigPath = appHome.path + "/.gitconfig"
        print("creating .gitconfig at \(toConfigPath)")
        
        var content = """
[credential]
    helper = store --file '\(appHome.path)/.git-credentials'
"""
        if let user = newPasswords.first?.user {
            content.append("""

[user]
    name = \(user)
""")
        }
        FileManager.default.createFile(atPath: toConfigPath, contents: content.data(using: .utf8))
    }
    
    fileprivate func writeGitCredentials(_ newPasswords: [Credential]) {
        guard let appHome = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: .applicationSupportDirectory, create: true) else { return }
        let toCredsPath = appHome.path + "/.git-credentials"
        let content = newPasswords.map { cred -> String in
            cred.url.absoluteString
        }.joined(separator: "\n")
        FileManager.default.createFile(atPath: toCredsPath, contents: content.data(using: .utf8))
    }
}

struct CredentialSettingsView_Previews: PreviewProvider {
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
