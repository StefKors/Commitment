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

struct FloatingPanelToolbarView: View {
    var body: some View {
        HStack {
            HStack {
                PanelRepoSelectView()
                Spacer()
                PanelBranchView()
            }
        }
    }
}

struct FloatingPanelSidebarView: View {
    @Binding var commitTitle: String
    @Binding var commitBody: String
    var quickCommitTitle: String?
    var handleSubmit: () -> Void

    enum Field: Hashable {
        case commitTitle
    }

    @FocusState private var focusedField: Field?

    var body: some View {
        VStack {
            Form {
                TextField("commitTitle", text: $commitTitle, prompt: Text("Summary (required)"), axis: .vertical)
                    .textFieldStyle(.plain)
                    .onSubmit { handleSubmit() }
                    .font(.system(size: 16).leading(.loose))
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
                .onSubmit { handleSubmit() }
            }

            Spacer()
        }
        .padding(16)
    }
}

struct FloatingPanelContentView: View {
    @EnvironmentObject private var repo: RepoState
    @EnvironmentObject private var model: AppModel

    var body: some View {
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
    }
}

struct FloatingPanelFooterView: View {
    @EnvironmentObject private var repo: RepoState

    var handleSubmit: () -> Void

    var body: some View {
        HStack {
            ActiveChangesStatsView(showBlocks: true)
            Spacer()
            Button {
                handleSubmit()
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
            .keyboardShortcut(.return, modifiers: .command)
        }
        .padding(16)
        .foregroundStyle(.secondary)
    }
}

struct QuickCommitPanelView: View {
    @EnvironmentObject private var repo: RepoState
    @State private var commitTitle: String = ""
    @State private var commitBody: String = ""

    private var quickCommitTitle: String? {
        if repo.status.count == 1, let first = repo.status.first, let str = first.path.split(separator: " -> ").last {
            let url = URL(filePath: String(str))
            return "Update \(url.lastPathComponent)"
        }

        return nil
    }

    private var placeholderTitle: String {
        if let title = quickCommitTitle {
            return title
        }

        return "Summary (Required)"
    }

    var body: some View {
        FloatingPanelExpandableLayout(toolbar: {
            FloatingPanelToolbarView()
        }, sidebar: {
            FloatingPanelSidebarView(
                commitTitle: $commitTitle,
                commitBody: $commitBody,
                quickCommitTitle: quickCommitTitle,
                handleSubmit: handleSubmit
            )
        }, content: {
            FloatingPanelContentView()
        }, footer: {
            FloatingPanelFooterView(handleSubmit: handleSubmit)
        })
        .touchBar(content: {
            TouchbarContentView()
        })
    }

    func handleSubmit() {
        Task { @MainActor in
            try await repo.commit(title: commitTitle, body: commitBody, quickCommitTitle: quickCommitTitle)
            commitTitle = ""
            commitBody = ""
        }
    }
}

struct QuickCommitPanelView_Previews: PreviewProvider {
    static var previews: some View {
        QuickCommitPanelView()
    }
}
