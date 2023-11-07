//
//  CredentialSettingsView.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI
import KeychainAccess
import SwiftData
import OSLog

fileprivate let log = Logger(subsystem: "com.stefkors.commitment", category: "CredentialSettingsView")

struct CredentialSettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var credentials: [Credential]
    @State private var gitName: String = ""
    @State private var gitEmail: String = ""
    @State private var showFileImporter: Bool = false

    var body: some View {
        SettingsBox(
            label: "Git Email"
        ) {
            Text("Set the email you want to use when commiting")
            TextField("Name", text: $gitName, prompt: Text("Jane Doe"))
                .onSubmit {

                    submitUser()
                }
            TextField("Email", text: $gitEmail, prompt: Text("janedoe@example.com"))
                .onSubmit {
                    submitUser()
                }
            .frame(alignment: .trailing)
        }

        SettingsBox(
            label: "Git-Credentials File"
        ) {
            Text(try! AttributedString(markdown: "Your git credentials can be parsed and imported from an `.git-credentials` file. Click import to get started."))
            if credentials.isNotEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(credentials) { credential in
                        CredentialView(credential: credential)
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
        .fileDialogBrowserOptions(.includeHiddenFiles)
        .fileDialogDefaultDirectory(URL(filePath: "~/"))
        .fileDialogMessage("Select your .git-credentials file")
        .fileDialogConfirmationLabel("Import")
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.directory]
        ) { result in
            switch result {
            case .success(let directory):
                // gain access to the directory
                let gotAccess = directory.startAccessingSecurityScopedResource()
                if !gotAccess {
                    log.error("Failed to start accessing directory \(directory.description)")
                    return
                }
                addItem(url: directory)
//                open(directory)
            case .failure(let error):
                // handle error
                print(error)
            }
        }
    }

    func submitUser() {
        print("submit git user")
        guard !gitName.isEmpty, !gitEmail.isEmpty else { return }
        print("TODO: handle git user stuff")
        // TODO: handle git user stuff
//        repo.setGitUser(GitUser(name: gitName, email: gitEmail))
    }

    /// Use NSOpenPanel to open the users git config and update the stored credentials.
    func handleImportAction() {
        print("TODO: handle git credentials stuff")
        // TODO: handle git credentials stuff
//        if let path = repo.bookmarks.openGitCredentials() {
//            if let content = try? String(contentsOf: URL(filePath: path.path()), encoding: .utf8) {
//                let oldPasswords = passwords?.values ?? []
//                let newPasswords = content
//                    .lines
//                    .compactMap { line -> Credential? in
//                        guard let url = URL(string: String(line)) else { return nil }
//                        return Credential(url: url)
//                    }
//                
//                let newValues = Array(Set(oldPasswords + newPasswords))
//                writeGitConfig(newValues)
//                writeGitCredentials(newValues)
//                
//                withAnimation(.easeOut(duration: 0.2)) {
//                    passwords = Credentials(values: newValues)
//                }
//            }
//        } else {
//            print("failed to get path")
//        }
    }

    private func addItem(url: URL) {
                    if let content = try? String(contentsOf: URL(filePath: url.path()), encoding: .utf8) {
                    }
        //                        let oldPasswords = passwords?.values ?? []
        //
        //
        //                        let newValues = Array(Set(oldPasswords + newPasswords))
        //                        writeGitConfig(newValues)
        //                        writeGitCredentials(newValues)
        //
        //                        withAnimation(.easeOut(duration: 0.2)) {
        //                            passwords = Credentials(values: newValues)
        //                        }
        withAnimation {
            let newCredential = Credential(path: url)
            modelContext.insert(newCredential)
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
            cred.path.absoluteString
        }.joined(separator: "\n")
        FileManager.default.createFile(atPath: toCredsPath, contents: content.data(using: .utf8))
    }
}

struct CredentialSettingsView_Previews: PreviewProvider {
    // Credentials(values: [
    //     Credential(url: URL(string:"....")!),
    //     Credential(url: URL(string:"....")!),
    //     Credential(url: URL(string:"....")!),
    // ])
    static var previews: some View {
        CredentialSettingsView()
            .frame(maxWidth: 450)
            .scenePadding()
    }
}
