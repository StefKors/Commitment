//
//  ContentPlaceholderView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI
import KeyboardShortcuts

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
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Push commits to the origin remote")
                            .fontWeight(.semibold)
                        Text("You have \(repo.commitsAhead.count) local commit waiting to be pushed to \(selectedExternalGitProvider).")
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
                            // TODO: Convert to activity
                            do {
                                _ = try await self.repo.shell.push()
                                self.repo.undo.stack = self.repo.undo.stack.filters(allOf: .commit)
                                try? await self.repo.refreshRepoState()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    })
                }
                .padding(.bottom, 4)

                PendingCommitSummaryView()
            }
            .scenePadding()
        }
        .groupBoxStyle(AccentBorderGroupBoxStyle())
    }
}

struct QuickCommitFeaturePlaceholder: View {
    @EnvironmentObject private var repo: RepoState

    var shortcut: [String] {
        let str = KeyboardShortcuts.Shortcut(name: .globalCommitPanel)?.description ?? ""
        return str.map { String($0) }
    }

    var body: some View {
        GroupBox {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Quick Commit Window")
                            .fontWeight(.semibold)
                        HStack {
                            Text("Open the global quick commit window with")
                            ForEach(shortcut, id: \.self) { key in
                                KeyboardKey(key: key)
                            }
                        }.foregroundStyle(.secondary)
                    }
                    Spacer()

                    Image(systemName: "keyboard")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }
                .padding(.bottom, 4)
            }
            .scenePadding()
        }
    }
}

struct GoCodeRepoPlaceholder: View {
    @EnvironmentObject private var repo: RepoState
    @AppStorage("SelectedExternalGitProvider") private var selectedExternalGitProvider: String = "GitHub"
    
    var body: some View {
        GroupBox {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Go make something great!")
                        .fontWeight(.semibold)
                    Text("Meanwhile Commitment will keep an eye out for changes.")
                        .foregroundStyle(.secondary)
                }
                Spacer()
                
                Image(systemName: "wand.and.stars.inverse")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.accentColor)
            }
            .scenePadding()
        }
        .groupBoxStyle(AccentBorderGroupBoxStyle())
    }
}

struct OpenRepoInEditorPlaceholder: View {
    @EnvironmentObject private var model: AppModel
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
                .keyboardShortcut(.init("a", modifiers: [.command, .shift]))
            }
            .scenePadding()
        }
    }
}

struct OpenRepoInFinderPlaceholder: View {
    @EnvironmentObject private var model: AppModel
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
                .keyboardShortcut("f", modifiers: [.command, .shift])
            }
            .scenePadding()
        }
    }
}

struct ContentPlaceholderView: View {
    @EnvironmentObject private var model: AppModel
    @EnvironmentObject private var repo: RepoState
    @AppStorage("SelectedExternalGitProvider") private var selectedExternalGitProvider: String = "GitHub"
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 10) {
                CommitContributionChartView()

                if repo.commitsAhead.count > 0 {
                    PushChangesRepoPlaceholder()
                } else {
                    GoCodeRepoPlaceholder()
                }

                OpenRepoInEditorPlaceholder()

                OpenRepoInFinderPlaceholder()

                QuickCommitFeaturePlaceholder()
            }
            .frame(minWidth: 400, maxWidth: 900, alignment: .topLeading)
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
