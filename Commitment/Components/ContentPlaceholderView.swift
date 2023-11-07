//
//  ContentPlaceholderView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI
import KeyboardShortcuts

struct PublishRepoPlaceholder: View {
    @Environment(CodeRepository.self) private var repository
    @AppStorage(Settings.Git.Provider) private var selectedExternalGitProvider: String = "GitHub"

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
                    self.repository.path.showInFinder()
                })
            }
            .scenePadding()
        }
        .groupBoxStyle(AccentBorderGroupBoxStyle())
    }
}

struct PushChangesRepoPlaceholder: View {
    @Environment(CodeRepository.self) private var repository
    @EnvironmentObject private var shell: Shell
    @EnvironmentObject private var undoState: UndoState
    @AppStorage(Settings.Git.Provider) private var selectedExternalGitProvider: String = "GitHub"

    var body: some View {
        GroupBox {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Push commits to the origin remote")
                            .fontWeight(.semibold)
                        Text("You have \(self.repository.commitsAhead.count) local commit waiting to be pushed to \(selectedExternalGitProvider).")
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
                                _ = try await self.shell.push()
                                self.undoState.stack = self.undoState.stack.filters(allOf: .commit)
                                try? await  self.repository.refreshRepoState()
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
    @Environment(CodeRepository.self) private var repository

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
    @Environment(CodeRepository.self) private var repository
    @AppStorage(Settings.Git.Provider) private var selectedExternalGitProvider: String = "GitHub"

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
    @AppStorage(Settings.Editor.ExternalEditor) private var externalEditor: ExternalEditor = ExternalEditors.xcode
    @Environment(CodeRepository.self) private var repository

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
                Button("Open in \(externalEditor.name)", action: {
                    self.repository.path.openInEditor(externalEditor)
                })
                .keyboardShortcut(.init("a", modifiers: [.command, .shift]))
            }
            .scenePadding()
        }
    }
}

struct OpenRepoInFinderPlaceholder: View {
    @Environment(CodeRepository.self) private var repository

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
                    self.repository.path.showInFinder()
                })
                .keyboardShortcut("f", modifiers: [.command, .shift])
            }
            .scenePadding()
        }
    }
}

struct ContentPlaceholderView: View {
    @Environment(CodeRepository.self) private var repository
    @AppStorage(Settings.Git.Provider) private var selectedExternalGitProvider: String = "GitHub"

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 10) {
                // TODO: figure out Commit Contribution Chart view
//                CommitContributionChartView(commits: self.repository.commits)
//                Divider()
                if self.repository.commitsAhead.count > 0 {
                    PushChangesRepoPlaceholder()
                } else {
                    GoCodeRepoPlaceholder()
                }

                OpenRepoInEditorPlaceholder()

                OpenRepoInFinderPlaceholder()

                QuickCommitFeaturePlaceholder()
            }
            // Fix some borders clipping
            .padding(2)
        }
        // .frame(maxWidth: 730, alignment: .trailing)
        .scenePadding()
    }
}

// struct ContentPlaceholderView_Previews: PreviewProvider {
//     static let repo = RepoState(string: URL(filePath: "/users/stefkors/Developer/Commitment")!
//     static var previews: some View {
//         ContentPlaceholderView()
//             .environmentObject(repo)
//     }
// }
