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
                Image(systemName: "arrow.up.and.down.and.sparkles")
                    .imageScale(.small)
                Text("Update Main")
                    .fontWeight(.bold)
                // Text("Update Main")
                //     .foregroundColor(.secondary)
            }
            .font(.system(size: 10))
            .foregroundColor(.primary)
        })
    }

    func handleButton() {
        let log = repo.shell.run("git fetch origin main:main")
        print(log)
    }
}

struct ToolbarActionUpdateMain_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarActionUpdateMain()
    }
}
