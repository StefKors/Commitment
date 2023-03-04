//
//  ToolbarActionButtonView.swift
//  Commitment
//
//  Created by Stef Kors on 30/01/2023.
//

import SwiftUI
import KeychainAccess

struct ToolbarPushOriginActionButtonView: View {
    @EnvironmentObject private var repo: RepoState
    @EnvironmentObject private var appModel: AppModel
    private let remote: String = "origin"

    @StateObject private var shell: ShellViewModel = .init()
    @State private var progress: CGFloat = 0
    var body: some View {
        Button(action: handleButton, label: {
            ViewThatFits {
                HStack {
                    ActivityArrow(isPushingBranch: shell.isRunning)
                    VStack(alignment: .leading) {
                        Text("Push \(remote)")
                        OutputLine(output: shell.output, date: repo.lastFetchedDate)
                    }.frame(maxWidth: 190, alignment: .leading)

                    GroupBox {
                        Text(repo.commitsAhead.description)
                    }
                }
                .foregroundColor(.primary)

                HStack {
                    ActivityArrow(isPushingBranch: shell.isRunning)
                    VStack(alignment: .leading) {
                        Text("Push \(remote)")
                        OutputLine(output: shell.output, date: repo.lastFetchedDate)
                    }
                }
                .foregroundColor(.primary)

                HStack {
                    ActivityArrow(isPushingBranch: shell.isRunning)
                    Text("Push \(remote)")
                }
                .foregroundColor(.primary)
            }
        })
        .buttonStyle(.plain)
        .animation(.easeIn(duration: 0.35), value: shell.isRunning)
    }

    func handleButton() {
        Task {
            do {
                shell.isRunning = true
                let remote = try await self.repo.shell.remote()
                let branch = try await self.repo.shell.branch()
                // TODO showing progress output line by line isn't working for git push
                await self.shell.run(.git, ["push", remote, branch], in: self.repo.shell.workspace)
                try? await self.repo.refreshRepoState()
                shell.isRunning = false
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct ToolbarActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarPushOriginActionButtonView()
    }
}
