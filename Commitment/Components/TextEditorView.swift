//
//  TextEditorView.swift
//  Commitment
//
//  Created by Stef Kors on 03/01/2023.
//

import SwiftUI

struct TextEditorView: View {
    let isDisabled: Bool
    @EnvironmentObject private var repo: RepoState
    // SceneStorage doesn't work well with textfield...
    // @SceneStorage("commitTitle") private var commitTitle: String = ""
    @State private var commitTitle: String = ""

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

    // SceneStorage doesn't work well with textfield...
    // @SceneStorage("commitBody") private var commitBody: String = ""
    @State private var commitBody: String = ""
    private let placeholderBody: String = "Body"

    var body: some View {
        Form {
            TextField("CommitTitle", text: $commitTitle, prompt: Text(placeholderTitle), axis: .vertical)
                .lineLimit(1)
                .multilineTextAlignment(.leading)
                .onSubmit { handleSubmit() }
                .textFieldStyle(.roundedBorder)

            TextField("Commitbody", text: $commitBody, prompt: Text(placeholderBody), axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...20)
                .multilineTextAlignment(.leading)
                .onSubmit { handleSubmit() }

            Button(action: { handleSubmit() }) {
                Spacer()
                Text("Commit")
                Text("to")
                Text(repo.branch)
                    .fontWeight(.bold)
                Spacer()
            }
            .buttonStyle(.borderedProminent)
            .disabled(isDisabled)
            .keyboardShortcut(.return, modifiers: .command)
        }
        .labelsHidden()
        .padding(.horizontal)
    }

    func handleSubmit() {
        Task { @MainActor in
            if !commitTitle.isEmpty, !commitBody.isEmpty {
                try? await repo.shell.commit(title: commitTitle, message: commitBody)
                commitTitle = ""
                commitBody = ""
            } else if !commitTitle.isEmpty {
                try? await repo.shell.commit(message: commitTitle)
                commitTitle = ""
            } else if let title = quickCommitTitle {
                try? await repo.shell.commit(message: title)
                commitTitle = ""
            }

            try? await repo.refreshRepoState()
        }
    }
}

struct TextEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorView(isDisabled: false)
        TextEditorView(isDisabled: true)
    }
}
