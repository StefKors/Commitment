//
//  ContentView.swift
//  Difference
//
//  Created by Stef Kors on 12/08/2022.
//

import SwiftUI

struct RepoWindow: View {
    // The user activity type representing this view.
    static let productUserActivityType = "com.stefkors.Commitment.repoview"

    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var repo: RepoState
    @EnvironmentObject private var model: AppModel

    var body: some View {
        HStack {
            MainRepoContentView()
            // .navigationDocument(URL(fileURLWithPath: state.repo.path.absoluteString, isDirectory: true))
                .toolbar(content: {
                    ToolbarItemGroup(placement: .keyboard, content: {
                        TouchbarContentView()
                    })
                })
        }
        .frame(minWidth: 400, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
        // .navigationTitle(repo.folderName)
        // .navigationSubtitle(repo.branch)
        .onChange(of: scenePhase) { phase in
            // Stop monitoring for file changes when app minimizes
            print("[Scene Change] App became: \(phase)")
            Task.detached(priority: .utility, operation: {
                try? await model.saveRepo(repo: repo)
            })
            switch phase {
            case .active:
                if let hasStarted = repo.monitor?.hasStarted, hasStarted == false {
                    repo.monitor?.start()
                }
            case .inactive, .background:
                if let hasStarted = repo.monitor?.hasStarted, hasStarted == true {
                    repo.monitor?.stop()
                }
            @unknown default:
                print("TODO: handle default scenePhase")
            }
        }
    }
}
