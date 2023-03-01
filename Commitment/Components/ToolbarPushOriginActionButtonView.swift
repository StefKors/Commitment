//
//  ToolbarActionButtonView.swift
//  Commitment
//
//  Created by Stef Kors on 30/01/2023.
//

import SwiftUI

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

            if let fromPath = Bundle.main.url(forResource: "", withExtension: ".gitconfig")?.absoluteString {
                let toPath = appHome.absoluteString + ".gitconfig"
                print("moving .gitconfig")
                try? FileManager.default.moveItem(atPath: fromPath, toPath: toPath)
            }

            if let fromPath = Bundle.main.url(forResource: "", withExtension: ".git-credentials")?.absoluteString {
                let toPath = appHome.absoluteString + ".git-credentials"
                print("moving .gitconfig")
                try? FileManager.default.moveItem(atPath: fromPath, toPath: toPath)
            }
            // let output = try await self.repo.shell.push()
            // print(output)
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
