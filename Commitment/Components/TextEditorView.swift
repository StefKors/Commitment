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
        }
        .labelsHidden()
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    func handleSubmit() {
        Task { @MainActor in
            if !commitTitle.isEmpty, !commitBody.isEmpty {
                try? await repo.shell.commit(title: commitTitle, message: commitBody)
                commitTitle = ""
                commitBody = ""
            } else if !commitTitle.isEmpty {
                try? await repo.shell.commit(message: commitTitle)
                withAnimation(.easeInOut) {
                    commitTitle = ""
                }
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
