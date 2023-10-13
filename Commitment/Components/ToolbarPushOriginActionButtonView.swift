//
//  ToolbarActionButtonView.swift
//  Commitment
//
//  Created by Stef Kors on 30/01/2023.
//

import SwiftUI
import KeychainAccess

struct ToolbarPushOriginActionButtonView: View {
    @EnvironmentObject private var repo: CodeRepository
    @EnvironmentObject private var activityState: ActivityState
    @EnvironmentObject private var undoState: UndoState
    @EnvironmentObject private var shell: Shell

    private let remote: String = "origin"

    @State private var progress: CGFloat = 0

    var body: some View {
        Button(action: handleButton, label: {
            ViewThatFits {
                HStack {
                    ActivityArrow(isPushingBranch: activityState.isPushing)
                    VStack(alignment: .leading) {
                        Text("Push \(remote)")
                        // TODO: shell activity date
                        OutputLine(output: shell.output, date: nil)
                    }.frame(maxWidth: 190, alignment: .leading)

                    GroupBox {
                        Text(repo.commitsAhead.count.description)
                    }
                }
                .foregroundColor(.primary)

                HStack {
                    ActivityArrow(isPushingBranch: activityState.isPushing)
                    VStack(alignment: .leading) {
                        Text("Push \(remote)")
                        // TODO: shell activity date
                        OutputLine(output: shell.output, date: nil)
                    }
                }
                .foregroundColor(.primary)

                HStack {
                    ActivityArrow(isPushingBranch: activityState.isPushing)
                    Text("Push \(remote)")
                }
                .foregroundColor(.primary)
            }
        })
        .buttonStyle(.plain)
        .animation(.easeIn(duration: 0.35), value: activityState.isPushing)
        .keyboardShortcut(.init("p", modifiers: .command))
    }

    func handleButton() {
        Task {
            self.activityState.start(.isPushingBranch)
            do {
                _ = try await self.shell.push()
                self.undoState.stack = self.undoState.stack.filters(allOf: .commit)
                try await self.repo.refreshRepoState()
            } catch {
                print(error.localizedDescription)
            }
            self.activityState.finish(.isPushingBranch)
        }
    }
}
