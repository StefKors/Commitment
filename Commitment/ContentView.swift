//
//  ContentView.swift
//  Commitment
//
//  Created by Stef Kors on 06/04/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var git: GitClient

    var body: some View {
        TextEditorView()
            // .frame(width: 200, height: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
