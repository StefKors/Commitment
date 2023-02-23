//
//  ToolbarActionButtonView.swift
//  Commitment
//
//  Created by Stef Kors on 30/01/2023.
//

import SwiftUI

struct ToolbarActionButtonView: View {
    @EnvironmentObject private var repo: RepoState
    let remote: String = "origin"

    var body: some View {
        Button(action: handleButton, label: {
            HStack {
                Image(systemName: "arrow.up")
                    .imageScale(.small)

                VStack(alignment: .leading) {
                    Text("Push \(remote)")
                        // .fontWeight(.bold)
                    Text("Last fetched just now")
                        .foregroundColor(.secondary)
                }

                GroupBox {
                    Text(repo.commitsAhead.description)
                }
            }
            .foregroundColor(.primary)
        })
        .buttonStyle(.plain)
    }

    func handleButton() {
        Task {
            try? await self.repo.shell.push()
        }
    }
}

struct ToolbarActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarActionButtonView()
    }
}
