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
    @EnvironmentObject private var activity: ActivityState
    private let remote: String = "origin"

    @StateObject private var shell: Shell
    @State private var progress: CGFloat = 0

    // var isPushing: Bool {
    //     repo.activity.current == .isPushingBranch
    // }

    // @State private var isPushing: Bool = false


    var body: some View {
        // Text("\(isPushing.description)")
        // Text("\(isPushing.description)")
        Text("\(activity.isPushing.description)")
        Button(action: handleButton, label: {
            ViewThatFits {
                HStack {
                    ActivityArrow(isPushingBranch: activity.isPushing)
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
                    ActivityArrow(isPushingBranch: activity.isPushing)
                    VStack(alignment: .leading) {
                        Text("Push \(remote)")
                        OutputLine(output: shell.output, date: repo.lastFetchedDate)
                    }
                }
                .foregroundColor(.primary)

                HStack {
                    ActivityArrow(isPushingBranch: activity.isPushing)
                    Text("Push \(remote)")
                }
                .foregroundColor(.primary)
            }
        })
        .buttonStyle(.plain)
        .animation(.easeIn(duration: 0.35), value: activity.isPushing)
        .keyboardShortcut(.init("p", modifiers: .command))
    }

    func handleButton() {
        Task {
            withAnimation(.spring()) {
                // self.isPushing = true
            self.activity.start(.isPushingBranch)
            }
            do {
                _ = try await self.shell.push()
                self.repo.undo.stack = self.repo.undo.stack.filters(allOf: .commit)
                try await self.repo.refreshRepoState()
            } catch {
                print(error.localizedDescription)
            }
            withAnimation(.spring()) {
                self.activity.finish(.isPushingBranch)
                // self.isPushing = false
            }
        }
    }
}

// struct ToolbarActionButtonView_Previews: PreviewProvider {
//     static var previews: some View {
//         ToolbarPushOriginActionButtonView()
//     }
// }
