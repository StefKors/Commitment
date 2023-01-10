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
    @StateObject private var diffstate: DiffState = DiffState()
    
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
            
            DiffView(diffs: diffstate.diffs)
                .task {
                    self.diffstate.diffs = git.diff()
                }
        }
        .scenePadding()
    }
    
    func handleSubmit() {
        withAnimation {
            git.commit(message: message)
            message = ""
            self.diffstate.diffs = git.diff()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
