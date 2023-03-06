//
//  ToolbarActionUpdateMain.swift
//  Commitment
//
//  Created by Stef Kors on 02/02/2023.
//

import SwiftUI

// git fetch origin main:main will fetch udpates and apply them to local main
struct ToolbarActionUpdateMain: View {
    @EnvironmentObject private var repo: RepoState
    var body: some View {
        Button(action: handleButton, label: {
            HStack {
                Image(systemName: "arrow.turn.left.down")
                    .imageScale(.medium)
                VStack(alignment: .leading) {
                    Text("Update Main")
                    Text("Refresh in background")
                        .foregroundColor(.secondary)
                }
            }
            .foregroundColor(.primary)
        })
        .buttonStyle(.plain)
    }

    func handleButton() {
        Task {
            try? await repo.shell.fetch(branch: "main")
        }
    }
}

struct ToolbarActionUpdateMain_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarActionUpdateMain()
    }
}
