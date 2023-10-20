//
//  QuickCommitPanelView.swift
//  Commitment
//
//  Created by Stef Kors on 05/05/2023.
//

import SwiftUI

struct PanelRepoSelectView: View {
    @EnvironmentObject private var repo: CodeRepository

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
    @EnvironmentObject private var repo: CodeRepository

    var body: some View {
        HStack {
            Image("git-branch-16")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
                .foregroundStyle(.secondary)

            Text(repo.branch?.name.localName ?? "")
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

    private var placeholderTitle: String {
        if let title = quickCommitTitle {
            return title
        }

        return "Summary (Required)"
    }

    var body: some View {
        VStack {
            Form {
                TextField("commitTitle", text: $commitTitle, prompt: Text(placeholderTitle), axis: .vertical)
                    .textFieldStyle(.plain)
                    .onSubmit { handleSubmit() }
                    .font(.system(size: 16).leading(.loose))
                    .focused($focusedField, equals: .commitTitle)
                    .labelsHidden()
                    .task {
                        focusedField = .commitTitle
                    }
                    .lineLimit(1)

                MacEditorTextView(
                    text: $commitBody,
                    placeholder: "Please enter the commit message body for your changes.",
                    isFirstResponder: false,
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
    @EnvironmentObject private var repo: CodeRepository

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

                            Button("Open in \(repo.editor.rawValue)") {
                                if let last = fileStatus.path.split(separator: " -> ").last {
                                    let fullPath = repo.path.appending(path: last)
                                    fullPath.openInEditor(repo.editor)
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
    @EnvironmentObject private var repo: CodeRepository

    var handleSubmit: () -> Void

    var body: some View {
        HStack {
            ActiveChangesStatsView()
            Spacer()
            Button {
                handleSubmit()
            } label: {
                HStack {
                    Text("Commit to \(repo.branch?.name.localName ?? "")")
                    HStack(spacing: 0) {
                        Image(systemName: "command")
                        Image(systemName: "return")
                    }
                    .fontWeight(.semibold)
                    .imageScale(.small)
                }
            }
            .buttonStyleSubmitProminent()
            .keyboardShortcut(.return, modifiers: .command)
        }
        .padding(16)
    }
}

struct QuickCommitPanelView: View {
    @Binding var showPanel: Bool
    @EnvironmentObject private var repo: CodeRepository
    @EnvironmentObject private var shell: Shell
    @EnvironmentObject private var undoState: UndoState
    @State private var commitTitle: String = ""
    @State private var commitBody: String = ""

    private var quickCommitTitle: String? {
        print("todo: generate quick commit title")
//        if repo.status.count == 1, let first = repo.status.first, let str = first.path.split(separator: " -> ").last {
//            let url = URL(filePath: String(str))
//            return "Update \(url.lastPathComponent)"
//        }

        return nil
    }

    @State private var isSubmitting: Bool = false

    var body: some View {
        FloatingPanelExpandableLayout(isSubmitting: isSubmitting, toolbar: {
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
                .disabled((commitTitle + (quickCommitTitle ?? "")).isEmpty)
        })
        .animation(.stiffBounce, value: isSubmitting)
        .touchBar(content: {
            TouchbarContentView()
        })
    }

    func handleSubmit() {
        Task { @MainActor in
            isSubmitting = true
            try await self.commit(title: commitTitle, body: commitBody, quickCommitTitle: quickCommitTitle)
            showPanel = false
            commitTitle = ""
            commitBody = ""
            isSubmitting = false
        }
    }

    func commit(title: String, body: String, quickCommitTitle: String? = nil) async throws {
        var action: UndoAction?
        if !title.isEmpty, !body.isEmpty {
            try await self.shell.commit(title: title, message: body)
            action = UndoAction(type: .commit, arguments: ["commit", "-m", title, "-m", body], subtitle: title)
        } else if !title.isEmpty {
            try await self.shell.commit(message: title)
            action = UndoAction(type: .commit, arguments: ["commit", "-m", title], subtitle: title)
        } else if let title = quickCommitTitle {
            try await self.shell.commit(message: title)
            action = UndoAction(type: .commit, arguments: ["commit", "-m", title], subtitle: title)
        }

        if let action {
            self.undoState.stack.append(action)
        }

        try await self.repo.refreshRepoState()
    }
}

struct QuickCommitPanelView_Previews: PreviewProvider {
    static var previews: some View {
        QuickCommitPanelView(showPanel: .constant(true))
    }
}
