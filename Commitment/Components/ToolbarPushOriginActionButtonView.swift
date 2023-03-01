//
//  ToolbarActionButtonView.swift
//  Commitment
//
//  Created by Stef Kors on 30/01/2023.
//

import SwiftUI
import KeychainAccess

struct ActivityArrow: View {
    let isPushingBranch: Bool
    var body: some View {
        if isPushingBranch {
            Image(systemName: "arrow.2.circlepath")
                .imageScale(.medium)
                .rotation(isEnabled: true)
        } else {
            Image(systemName: "arrow.up")
                .imageScale(.medium)
        }
    }
}

struct ToolbarPushOriginActionButtonView: View {
    @EnvironmentObject private var repo: RepoState
    @EnvironmentObject private var appModel: AppModel
    let remote: String = "origin"

    @State private var isPushingBranch: Bool = false
    @State private var showMover: Bool = false

    var body: some View {
        Button(action: handleButton, label: {
            ViewThatFits {
                HStack {
                    ActivityArrow(isPushingBranch: isPushingBranch)
                    VStack(alignment: .leading) {
                        Text("Push \(remote)")
                        // .fontWeight(.bold)
                        Text("Last fetched just now")
                            .foregroundColor(.secondary)
                    }

                    GroupBox {
                        Text(repo.commitsAhead.description)
                    }
                }
                .foregroundColor(.primary)

                HStack {
                    ActivityArrow(isPushingBranch: isPushingBranch)
                    VStack(alignment: .leading) {
                        Text("Push \(remote)")
                        // .fontWeight(.bold)
                        Text("Last fetched just now")
                            .foregroundColor(.secondary)
                    }
                }
                .foregroundColor(.primary)

                HStack {
                    ActivityArrow(isPushingBranch: isPushingBranch)
                    Text("Push \(remote)")
                }
                .foregroundColor(.primary)
            }
        })
        .buttonStyle(.plain)
    }

    func handleButton() {
        Task {
            withAnimation(.interpolatingSpring(stiffness: 300, damping: 15)) {
                isPushingBranch = true
            }

            let appHome = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: .applicationSupportDirectory, create: true)

            if let fromPath = Bundle.main.url(forResource: "", withExtension: ".gitconfig")?.path {
                let toPath = appHome.path + "/.gitconfig"
                print("creating .gitconfig at \(toPath)")

                    let content = """
[credential]
    helper = store --file '\(appHome.path)/.git-credentials'
"""
                    FileManager.default.createFile(atPath: toPath, contents: content.data(using: .utf8))
                    // do {
                    //     try FileManager.default.moveItem(atPath: fromPath, toPath: toPath)
                    // } catch {
                    //     print(error.localizedDescription)
                    // }
            }



                let toPath = appHome.path + "/.git-credentials"
                print("creating .gitconfig")
                // do {


            if let data = try Keychain().getData("passwords") {
                let credentials = try JSONDecoder().decode(Credentials.self, from: data)
                let content = credentials.values.map { cred -> String in
                    cred.url.absoluteString
                }.joined(separator: "\n")
                FileManager.default.createFile(atPath: toPath, contents: content.data(using: .utf8))
            }
            // let output = try? await repo.shell.listConfig()
            // print(output)
            // let output2 = try await self.repo.shell.push()
            // print(output2)
            //
            // let path = try await self.repo.shell.execPath()
            // print(path)

            try await self.repo.refreshRepoState()
            withAnimation(.interpolatingSpring(stiffness: 300, damping: 15)) {
                isPushingBranch = false
            }
        }
    }
}

struct ToolbarActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarPushOriginActionButtonView()
    }
}
