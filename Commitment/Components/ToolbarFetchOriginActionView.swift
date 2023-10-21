//
//  ToolbarFetchOriginActionView.swift
//  Commitment
//
//  Created by Stef Kors on 25/02/2023.
//

import SwiftUI

struct ToolbarFetchOriginActionView: View {
    @Environment(CodeRepository.self) private var repository
    let remote: String = "origin"
    @EnvironmentObject private var shell: Shell

    // TODO: implement
    var body: some View {
        Button(action: handleButton, label: {
            ViewThatFits {
                HStack {
                    Image(systemName: "arrow.2.circlepath")
                        .imageScale(.medium)

                    VStack(alignment: .leading) {
                        Text("Fetch \(remote)")
                        // TODO: handle date in shell
                        OutputLine(output: shell.output, date: nil)
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
            // TODO: Activity and Shell wombo combo
            // shell.isRunning = true
//            await self.shell.runActivity(.git, ["fetch", "origin", "main"], in: repo.shell.workspace)
//            shell.output = nil
            // shell.isRunning = false
            // try? await  self.repository.shell.push()
        }
    }
}

struct ToolbarFetchOriginActionView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarFetchOriginActionView()
    }
}
