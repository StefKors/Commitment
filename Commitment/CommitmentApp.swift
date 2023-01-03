//
//  CommitmentApp.swift
//  Commitment
//
//  Created by Stef Kors on 06/04/2022.
//

import SwiftUI

@main
struct CommitmentApp: App {
    @StateObject var git = GitClient(workspace: "~/Developer/Commitment")

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(git)
                .toolbar {
                    ToolbarItem {
                        Button(action: commit, label: {
                            Text("run git commit")
                        })
                    }
                }
        }.windowToolbarStyle(.unified)
    }


    func commit() {
        print("commit!")
        git.commit(message: "testing commit \(Date.now.debugDescription)")
    }
}
