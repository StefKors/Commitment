//
//  ContentPlaceholderView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI

struct PublishRepoPlaceholder: View {
    @EnvironmentObject private var repo: RepoState
    @AppStorage("SelectedExternalGitProvider") private var selectedExternalGitProvider: String = "GitHub"

    var body: some View {
        GroupBox {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Publish your repository to \(selectedExternalGitProvider)")
                        .fontWeight(.semibold)
                    Text("This repository is currently only available on your local machine. By publishing it on \(selectedExternalGitProvider) you can share it, and collaborate with others.")
                        .foregroundStyle(.secondary)
                    HStack {
                        Text("Always available in the toolbar for local repositories or")
                        KeyboardKey(key: "⌘")
                        KeyboardKey(key: "P")
                    }.foregroundStyle(.secondary)
                }
                Spacer()
                Button("Publish repository", action: {
                    repo.path.showInFinder()
                })
            }
            .scenePadding()
        }
        .groupBoxStyle(AccentBorderGroupBoxStyle())
    }
}

struct PushChangesRepoPlaceholder: View {
    @EnvironmentObject private var repo: RepoState
    @AppStorage("SelectedExternalGitProvider") private var selectedExternalGitProvider: String = "GitHub"

    var body: some View {
        GroupBox {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Push commits to the origin remote")
                        .fontWeight(.semibold)
                    Text("You have \(repo.commitsAhead) local commit waiting to be pushed to \(selectedExternalGitProvider).")
                        .foregroundStyle(.secondary)
                    HStack {
                        Text("Always available in the toolbar for local commits or")
                        KeyboardKey(key: "⌘")
                        KeyboardKey(key: "P")
                    }.foregroundStyle(.secondary)
                }
                Spacer()
                Button("Push commits", action: {
                    Task {
                        // TODO: a way to show progress in toolbar button
                        do {
                            let remote = try await self.repo.shell.remote()
                            let branch = try await self.repo.shell.branch()
                            try? await self.repo.shell.run(.git, ["push", remote, branch], in: self.repo.shell.workspace)
                            try? await self.repo.refreshRepoState()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                })
            }
            .scenePadding()
        }
        .groupBoxStyle(AccentBorderGroupBoxStyle())
    }
}

struct OpenRepoInEditorPlaceholder: View {
    @EnvironmentObject var model: AppModel
    @EnvironmentObject private var repo: RepoState

    var body: some View {
        GroupBox {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Open repository in your external editor")
                        .fontWeight(.semibold)
                    HStack {
                        Text("Repository menu or")
                        KeyboardKey(key: "⌘")
                        KeyboardKey(key: "⇧")
                        KeyboardKey(key: "A")
                    }.foregroundStyle(.secondary)
                }
                Spacer()
                Button("Open in \(model.editor.name)", action: {
                    repo.path.openInEditor(model.editor)
                })
            }
            .scenePadding()
        }
    }
}

struct OpenRepoInFinderPlaceholder: View {
    @EnvironmentObject var model: AppModel
    @EnvironmentObject private var repo: RepoState

    var body: some View {
        GroupBox {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("View files of your repository in Finder")
                        .fontWeight(.semibold)
                    HStack {
                        Text("Repository menu or")
                        KeyboardKey(key: "⌘")
                        KeyboardKey(key: "⇧")
                        KeyboardKey(key: "F")
                    }.foregroundStyle(.secondary)
                }
                Spacer()
                Button("Show in Finder", action: {
                    repo.path.showInFinder()
                })
            }
            .scenePadding()
        }
    }
}


struct ContentPlaceholderView: View {
    @EnvironmentObject var model: AppModel
    @EnvironmentObject private var repo: RepoState
    @AppStorage("SelectedExternalGitProvider") private var selectedExternalGitProvider: String = "GitHub"

    var body: some View {
        ScrollView(.vertical) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("No local changes")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .fixedSize(horizontal: true, vertical: false)
                        Text("There are no uncommited changes in this repository. Here are some friendly suggestions for what to do next:")
                            .lineSpacing(4)
                    }
                    .frame(minWidth: 400, maxWidth: 600)

                    VStack(alignment: .leading, spacing: 10) {
                        PushChangesRepoPlaceholder()
                            .disabled(repo.commitsAhead == 0)

                        OpenRepoInEditorPlaceholder()

                        OpenRepoInFinderPlaceholder()
                    }
                    .frame(minWidth: 400, maxWidth: 600, alignment: .topLeading)
                }
                .padding()
            }
        }.scenePadding()
    }
}

// struct ContentPlaceholderView_Previews: PreviewProvider {
//     static let repo = RepoState(string: URL(filePath: "/users/stefkors/Developer/Commitment")!
//     static var previews: some View {
//         ContentPlaceholderView()
//             .environmentObject(repo)
//     }
// }
