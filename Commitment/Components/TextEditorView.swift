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
    private let placeholder: String = "Summary"
    @State private var message: String = ""

    var body: some View {
            VStack {
                TextField("CommitMessage", text: $message, prompt: Text(placeholder), axis: .vertical)
                    .lineLimit(2...20)
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(.plain)
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
            }
            .padding()
    }

    func handleSubmit() {
        repo.shell.commit(message: message)
        message = ""
        repo.refreshRepoState()
    }
}

struct TextEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorView(isDisabled: false)
        TextEditorView(isDisabled: true)
    }
}
