//
//  ContentView.swift
//  Commitment
//
//  Created by Stef Kors on 06/04/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var git: GitClient
    @State private var message: String = ""

    var body: some View {
        VStack {
            HStack {
                TextEditorView(message: $message)
                    .onSubmit { handleSubmit() }

                Button(action: { handleSubmit() }) {
                    Text("Commit")
                }
                .buttonStyle(.borderedProminent)
                .disabled(message.isEmpty)
            }

            DiffView()
        }
        .scenePadding()
    }

    func handleSubmit() {
        git.commit(message: message)
        message = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
