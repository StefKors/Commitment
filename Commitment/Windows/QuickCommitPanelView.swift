//
//  QuickCommitPanelView.swift
//  Commitment
//
//  Created by Stef Kors on 05/05/2023.
//

import SwiftUI

struct PanelRepoSelectView: View {
    @EnvironmentObject private var repo: RepoState

    var body: some View {
        HStack {
            Image("git-repo-16")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
                .foregroundStyle(.secondary)

            Text(self.repo.folderName)
                .foregroundStyle(.primary)
        }
    }
}

struct PanelBranchView: View {
    @EnvironmentObject private var repo: RepoState

    var body: some View {
        HStack {
            Image("git-branch-16")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
                .foregroundStyle(.secondary)

            Text(repo.branch)
                .foregroundStyle(.primary)
        }
    }
}

struct QuickCommitPanelView: View {
    @EnvironmentObject private var repo: RepoState
    @EnvironmentObject private var model: AppModel

    @State private var commitTitle: String = ""
    @State private var commitBody: String = ""

    enum Field: Hashable {
        case commitTitle
    }

    @FocusState private var focusedField: Field?

    var body: some View {
        FloatingPanelExpandableLayout(toolbar: {
            HStack {
                HStack {
                    PanelRepoSelectView()
                    Spacer()
                    PanelBranchView()
                }
            }
        }, sidebar: {
            VStack {
                Form {
                    TextField("commitTitle", text: $commitTitle, prompt: Text("Change several files to be different than before"), axis: .vertical)
                        .textFieldStyle(.plain)
                        .font(.system(size: 18).leading(.loose))
                        .focused($focusedField, equals: .commitTitle)
                        .labelsHidden()
                        .task {
                            focusedField = .commitTitle
                        }

                    MacEditorTextView(
                        text: $commitBody,
                        placeholder: "This commit updates several files in the codebase to include some code that they didn't have before, as well as removes some code they did have before.",
                        isFirstResponder: true,
                        font: NSFont.systemFont(ofSize: 13)
                    )
                }

                Spacer()
            }
            .padding(16)
        }, content: {
            ScrollView(.vertical) {
                VStack {
                    ForEach(repo.status, id: \.id) { fileStatus in
                        GitFileStatusView(fileStatus: fileStatus)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .contextMenu {
                                Button("Reveal in Finder") {
                                    if let last = fileStatus.path.split(separator: " -> ").last {
                                        let fullPath = repo.path.appending(path: last)
                                        fullPath.showInFinder()
                                    }
                                }
                                .keyboardShortcut("o")

                                Button("Open in \(model.editor.name)") {
                                    if let last = fileStatus.path.split(separator: " -> ").last {
                                        let fullPath = repo.path.appending(path: last)
                                        fullPath.openInEditor(model.editor)
                                    }
                                }
                                .keyboardShortcut("o", modifiers: [.command, .shift])

                                Divider()

                                Button("Copy File Path") {
                                    if let last = fileStatus.path.split(separator: " -> ").last {
                                        let fullPath = repo.path.appending(path: last)
                                        copyToPasteboard(text: fullPath.relativePath)
                                    }
                                }
                                .keyboardShortcut("c")

                                Button("Copy Relative File Path") {
                                    if let last = fileStatus.path.split(separator: " -> ").last {
                                        copyToPasteboard(text: String(last))
                                    }
                                }
                                .keyboardShortcut("c", modifiers: [.command, .shift])

                                Divider()

                                Button {
                                    Task {
                                        await repo.discardActiveChange(path: fileStatus.path)
                                    }
                                } label: {
                                    Text("Discard Changes")
                                }
                                .keyboardShortcut(.delete)
                            }
                    }
                    Spacer()
                }.padding()
            }
        }, footer: {
            HStack {
                Text("8 files changed")
                Text("+15")
                    .foregroundColor(Color("GitHubDiffGreenBright"))
                Text("-3")
                    .foregroundColor(Color("GitHubDiffRedBright"))
                Spacer()
                Button {
                    //
                } label: {
                    HStack {
                        Text("Commit to \(repo.branch)")
                        HStack(spacing: 0) {
                            Image(systemName: "command")
                            Image(systemName: "return")
                        }
                        .fontWeight(.semibold)
                        .opacity(0.8)
                        .imageScale(.small)
                        .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.borderedProminent)

                // Text("+\(stats.insertions)")
                //     .foregroundColor(Color("GitHubDiffGreenBright"))
                // Text("-\(stats.deletions)")
                //     .foregroundColor(Color("GitHubDiffRedBright"))
            }
            .padding(16)
            .foregroundStyle(.secondary)
        })
    }
}

struct QuickCommitPanelView_Previews: PreviewProvider {
    static var previews: some View {
        QuickCommitPanelView()
    }
}
