//
//  TextEditorView.swift
//  Commitment
//
//  Created by Stef Kors on 03/01/2023.
//

import SwiftUI

struct TextEditorView: View {
    @EnvironmentObject private var state: WindowState
    private let placeholder: String = "Summary"
    @State private var message: String = ""

    var body: some View {
        GroupBox {
            VStack {
                TextField("CommitMessage", text: $message, prompt: Text(placeholder), axis: .vertical)
                    .lineLimit(2...20)
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(.plain)
                // .font(Font.custom("Inter-Regular", size: 14))
                    .onSubmit { handleSubmit() }

                Button(action: { handleSubmit() }) {
                    Text("Commit")
                    Spacer()
                }
                .buttonStyle(.borderedProminent)
                .disabled(message.isEmpty)
            }
        }
        .background(.thinMaterial)
        .padding(4)
        .shadow(radius: 10)
    }

    func handleSubmit() {
        state.repo?.shell.commit(message: message)
        message = ""
        // self.diffstate.diffs = git.diff()
    }
}
// 
// struct TextEditorView_Previews: PreviewProvider {
//     static var previews: some View {
//         TextEditorView()
//     }
// }
