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

    // @FocusState private var titleFieldIsFocused: Bool
    @State private var commitTitle: String = ""
    private let placeholderTitle: String = "Summary (Required)"

    // @FocusState private var bodyFieldIsFocused: Bool
    @State private var commitBody: String = ""
    private let placeholderBody: String = "Body"


    var body: some View {
            VStack {
                // GroupBox {
                // TODO: limit to 50 chars
                    TextField("CommitTitle", text: $commitTitle, prompt: Text(placeholderTitle), axis: .vertical)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                        // .textFieldStyle(.roundedBorder)
                        .onSubmit { handleSubmit() }
                        // .focused($titleFieldIsFocused)
                        // .padding()
                        // .background(.thinMaterial)
                        // .background(
                        //     RoundedRectangle(cornerRadius: 5)
                        //         .stroke(.separator, lineWidth: 1)
                        // )
                // }.groupBoxStyle(MaterialAccentBorderGroupBoxStyle(isActive: titleFieldIsFocused))

                // GroupBox {
                    TextField("Commitbody", text: $commitBody, prompt: Text(placeholderBody), axis: .vertical)
                        .lineLimit(3...20)
                        .multilineTextAlignment(.leading)
                        // .textFieldStyle(.roundedBorder)
                        .onSubmit { handleSubmit() }
                        // .focused($bodyFieldIsFocused)
                // }.groupBoxStyle(MaterialAccentBorderGroupBoxStyle(isActive: bodyFieldIsFocused))

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
            .padding(.horizontal)
            .padding(.bottom)
    }

    func handleSubmit() {
        // TODO: handle is disabled
        Task(priority: .userInitiated) {
            if !commitTitle.isEmpty, !commitBody.isEmpty {
                try? await repo.shell.commit(title: commitTitle, message: commitBody)
                commitTitle = ""
                commitBody = ""
            } else if !commitTitle.isEmpty {
                try? await repo.shell.commit(message: commitTitle)
                commitTitle = ""
            }

            repo.refreshRepoState()

        }
    }
}

struct TextEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorView(isDisabled: false)
        TextEditorView(isDisabled: true)
    }
}
