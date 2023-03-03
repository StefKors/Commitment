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
        ZStack {
            if isPushingBranch {
                Image(systemName: "arrow.2.circlepath")
                    .imageScale(.medium)
                    .rotation(isEnabled: true)
                    .frame(width: 18, height: 18, alignment: .center)
                    .transition(.opacity.animation(.easeInOut(duration: 0.2)))
            } else {
                Image(systemName: "arrow.up")
                    .imageScale(.medium)
                    .frame(width: 18, height: 18, alignment: .center)
                    .transition(.opacity.animation(.easeInOut(duration: 0.1)))
            }
        }
        .contentTransition(.interpolate)
    }
}

struct ToolbarPushOriginActionButtonView: View {
    @EnvironmentObject private var repo: RepoState
    @EnvironmentObject private var appModel: AppModel
    private let remote: String = "origin"

    @StateObject private var shell: ShellViewModel = .init()

    var body: some View {
        Button(action: handleButton, label: {
            ViewThatFits {
                HStack {
                    ActivityArrow(isPushingBranch: shell.isRunning)
                    VStack(alignment: .leading) {
                        Text("Push \(remote)")
                        if let output = shell.output {
                            Text(output)
                                .lineLimit(1)
                                .foregroundColor(.secondary)
                                .contentTransition(.interpolate)
                                .animation(.easeIn(duration: 0.35), value: shell.output)
                        } else {
                            Text("Last fetched just now")
                                .foregroundColor(.secondary)

                            // .transition(.move(edge: .bottom))
                        }
                    }.frame(width: 170, alignment: .leading)

                    GroupBox {
                        Text(repo.commitsAhead.description)
                    }
                }
                .foregroundColor(.primary)

                HStack {
                    ActivityArrow(isPushingBranch: shell.isRunning)
                    VStack(alignment: .leading) {
                        Text("Push \(remote)")
                        Text("Last fetched just now")
                            .foregroundColor(.secondary)
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
    }

    func handleButton() {
        Task {
            let remote = try await self.repo.shell.remote()
            let branch = try await self.repo.shell.branch()
            await self.shell.run(.git, ["push", remote, branch], in: self.repo.shell.workspace)
            try? await self.repo.refreshRepoState()
        }
    }
}
//
// struct ToolbarActionButtonView_Previews: PreviewProvider {
//     static var previews: some View {
//         // ToolbarPushOriginActionButtonView()
//     }
// }
