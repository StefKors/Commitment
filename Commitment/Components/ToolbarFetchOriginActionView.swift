//
//  ToolbarFetchOriginActionView.swift
//  Commitment
//
//  Created by Stef Kors on 25/02/2023.
//

import SwiftUI

struct ToolbarFetchOriginActionView: View {
    @EnvironmentObject private var repo: RepoState
    let remote: String = "origin"

    // TODO: implement
    var body: some View {
        Button(action: handleButton, label: {
            ViewThatFits {
                HStack {
                    Image(systemName: "arrow.2.circlepath")
                        .imageScale(.medium)

                    VStack(alignment: .leading) {
                        Text("Fetch \(remote)")
                        Text("Last fetched just now")
                            .foregroundColor(.secondary)
                    }
                }
                .foregroundColor(.primary)
            }
        })
        .buttonStyle(.plain)
        .disabled(true)
    }

    func handleButton() {
        Task {
            // try? await self.repo.shell.push()
        }
    }
}

struct ToolbarFetchOriginActionView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarFetchOriginActionView()
    }
}
