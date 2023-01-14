//
//  ContentView.swift
//  Difference
//
//  Created by Stef Kors on 12/08/2022.
//

import SwiftUI
import Git

struct RepoWindow: View {
    // The user activity type representing this view.
    static let productUserActivityType = "com.stefkors.Commitment.repoview"

    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var repo: RepoState

    var body: some View {
        HStack {
            CommitHistorySplitView()
            // .navigationDocument(URL(fileURLWithPath: state.repo.path.absoluteString, isDirectory: true))
                .toolbar(content: {
                    ToolbarItemGroup(placement: .principal, content: {
                        ToolbarContentView()
                    })

                    ToolbarItemGroup(placement: .keyboard, content: {
                        ToolbarContentView()
                    })
                })
        }
        .frame(minWidth: 400, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
        .navigationTitle(repo.folderName)
        .navigationSubtitle(repo.branch)
        .task {
            repo.initializeFullRepo()
        }
        .onChange(of: scenePhase) { phase in
            // Stop monitoring for file changes when app minimizes
            print("[Scene Change] App became: \(phase)")
            switch phase {
            case .active:
                if let hasStarted = repo.monitor?.hasStarted, hasStarted == false {
                    repo.monitor?.start()
                }
            case .inactive:
                if let hasStarted = repo.monitor?.hasStarted, hasStarted == true {
                    repo.monitor?.stop()
                }
            // case .background:
                // todo?
            case .background:
                print("TODO: handle background scenePhase")
            @unknown default:
                print("TODO: handle default scenePhase")
            }
        }
    }
}
