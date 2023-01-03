//
//  TextEditorView.swift
//  Commitment
//
//  Created by Stef Kors on 03/01/2023.
//

import SwiftUI

struct TextEditorView: View {
    @EnvironmentObject private var git: GitClient
    @State private var message: String = ""
    private let placeholder: String = "Summary"
    var body: some View {
        HStack() {
            TextField("CommitMessage", text: $message, prompt: Text(placeholder))
                .onSubmit { handleSubmit() }
                .textFieldStyle(.plain)
                .multilineTextAlignment(.leading)

            Button(action: { handleSubmit() }) {
                Text("Commit")
            }
        }
        .scenePadding()
        .font(Font.custom("Inter-Regular", size: 18))
    }

    func handleSubmit() {
        print("submitting")
        git.commit(message: message)
        message = ""
    }
}

struct TextEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorView()
    }
}
