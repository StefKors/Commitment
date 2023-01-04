//
//  TextEditorView.swift
//  Commitment
//
//  Created by Stef Kors on 03/01/2023.
//

import SwiftUI

struct TextEditorView: View {
    @EnvironmentObject private var git: GitClient
    private let placeholder: String = "Summary"

    @Binding var message: String

    var body: some View {
        TextField("CommitMessage", text: $message, prompt: Text(placeholder), axis: .vertical)
            .lineLimit(1...20)
            .multilineTextAlignment(.leading)
            .textFieldStyle(.plain)
            .font(Font.custom("Inter-Regular", size: 18))
    }

}

struct TextEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorView(message: .constant("Commit message"))
    }
}
