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

    enum Field: Hashable {
        case commitTitle
    }

    @FocusState private var focusedField: Field?
    
    var body: some View {
        Form {

            HStack {
                if let user = repo.user {
                    AvatarView(email: user.email)
                        .shadow(radius: 2)
                }

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
                
            }

            MacEditorTextView(
                text: $commitBody,
                placeholder: "Please enter the commit message body for your changes.",
                isFirstResponder: false,
                font: NSFont.systemFont(ofSize: 13)
            )
            .frame(maxHeight: 65)
            .onSubmit { handleSubmit() }

            Button {
                handleSubmit()
            } label: {
                HStack {
                    Text("Commit to \(repo.branch)")
                    Spacer()
                    HStack(spacing: 0) {
                        Image(systemName: "command")
                        Image(systemName: "return")
                    }
                    .fontWeight(.semibold)
                    .imageScale(.small)
                }
            }
            .buttonStyleSubmitProminent()
            .disabled(isDisabled || (commitTitle + (quickCommitTitle ?? "")).isEmpty)
            .keyboardShortcut(.return, modifiers: .command)
        }
        .labelsHidden()
        .padding(.horizontal)
    }
    
    func handleSubmit() {
        Task { @MainActor in
            try await repo.commit(title: commitTitle, body: commitBody, quickCommitTitle: quickCommitTitle)
            commitTitle = ""
            commitBody = ""
        }
    }
}

struct TextEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorView(isDisabled: false)
        TextEditorView(isDisabled: true)
    }
}





