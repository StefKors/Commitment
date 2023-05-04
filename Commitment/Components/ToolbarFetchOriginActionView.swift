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
    @StateObject private var shell: Shell

    internal init(workspace: URL) {
        self._shell = StateObject(wrappedValue: Shell(workspace: workspace))
    }

    // TODO: implement
    var body: some View {
        Button(action: handleButton, label: {
            ViewThatFits {
                HStack {
                    Image(systemName: "arrow.2.circlepath")
                        .imageScale(.medium)

                    VStack(alignment: .leading) {
                        Text("Fetch \(remote)")
                        OutputLine(output: shell.output, date: repo.lastFetchedDate)
                    }
                }
                .foregroundColor(.primary)
            }
        })
        .buttonStyle(.plain)
        // .disabled(true)
    }

    func handleButton() {
        Task {
            // shell.isRunning = true
            await self.shell.runActivity(.git, ["fetch", "origin", "main"], in: repo.shell.workspace)
            shell.output = nil
            // shell.isRunning = false
            // try? await self.repo.shell.push()
        }
    }
}

struct ToolbarFetchOriginActionView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarFetchOriginActionView(workspace: .temporaryDirectory)
    }
}
