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
        List(git.commitHistory(entries: 10), id: \.hash) { commit in
            VStack(alignment: .leading) {
                Text(commit.author)
                Text(commit.message)
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
