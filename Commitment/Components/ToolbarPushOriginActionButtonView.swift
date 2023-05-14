//
//  ToolbarActionButtonView.swift
//  Commitment
//
//  Created by Stef Kors on 30/01/2023.
//

import SwiftUI
import KeychainAccess

struct ToolbarPushOriginActionButtonView: View {
    internal init(workspace: URL) {
        self._shell = StateObject(wrappedValue: Shell(workspace: workspace))
    }

    @EnvironmentObject private var repo: RepoState
    @EnvironmentObject private var appModel: AppModel
    private let remote: String = "origin"

    @StateObject private var shell: Shell
    @State private var progress: CGFloat = 0

    var isPushing: Bool {
        repo.activity.current == .isPushingBranch
    }


    var body: some View {
        Button(action: handleButton, label: {
            Text("\(repo.activity.current.debugDescription)")
            ViewThatFits {
                HStack {
                    ActivityArrow(isPushingBranch: isPushing)
                    VStack(alignment: .leading) {
                        Text("Push \(remote)")
                        OutputLine(output: shell.output, date: repo.lastFetchedDate)
                    }.frame(maxWidth: 190, alignment: .leading)

                    GroupBox {
                        Text(repo.commitsAhead.count.description)
                    }
                }
                .foregroundColor(.primary)

                HStack {
                    ActivityArrow(isPushingBranch: isPushing)
                    VStack(alignment: .leading) {
                        Text("Push \(remote)")
                        OutputLine(output: shell.output, date: repo.lastFetchedDate)
                    }
                }
                .foregroundColor(.primary)

                HStack {
                    ActivityArrow(isPushingBranch: isPushing)
                    Text("Push \(remote)")
                }
                .foregroundColor(.primary)
            }
        })
        .buttonStyle(.plain)
        .animation(.easeIn(duration: 0.35), value: isPushing)
        .keyboardShortcut(.init("p", modifiers: .command))
    }

    func handleButton() {
        Task {
            self.repo.activity.start(.isPushingBranch)
            do {
                _ = try await self.shell.push()
                self.repo.undo.stack = self.repo.undo.stack.filters(allOf: .commit)
                try await self.repo.refreshRepoState()
            } catch {
                print(error.localizedDescription)
            }
            self.repo.activity.finish(.isPushingBranch)
        }
    }
}

// struct ToolbarActionButtonView_Previews: PreviewProvider {
//     static var previews: some View {
//         ToolbarPushOriginActionButtonView()
//     }
// }
