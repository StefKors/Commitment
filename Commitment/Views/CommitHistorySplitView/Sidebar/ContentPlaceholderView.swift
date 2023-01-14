//
//  ContentPlaceholderView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI

struct ContentPlaceholderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("No local changes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .fixedSize(horizontal: true, vertical: false)
                Text("There are no uncommited changes in this repository. Here are some friendly suggestions for what to do next:")
                    .lineSpacing(4)
            }
            WelcomeRepoListView()
        }
        .frame(maxWidth: 400)
        .padding()
    }
}

struct ContentPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        ContentPlaceholderView()
    }
}
