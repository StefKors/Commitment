//
//  ContentView.swift
//  Difference
//
//  Created by Stef Kors on 12/08/2022.
//

import SwiftUI
import KeychainAccess
import KeyboardShortcuts

struct RepoWindow: View {
    // The user activity type representing this view.
    static let productUserActivityType = "com.stefkors.Commitment.repoview"

    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var repo: RepoState
    @EnvironmentObject private var model: AppModel
    // TODO: onboarding
    // @State private var showOnboarding: Bool = false
    // @KeychainStorage("passwords") private var passwords: Credentials? = nil
    @State private var showPanel: Bool = false
    var body: some View {
        HStack {
            MainRepoContentView()
            // .navigationDocument(URL(fileURLWithPath: state.repo.path.absoluteString, isDirectory: true))
        }
        .touchBar(content: {
            TouchbarContentView()
        })
        .floatingPanel(isPresented: $showPanel) {
            QuickCommitPanelView(showPanel: $showPanel)
                .environmentObject(repo)
                .environmentObject(model)
        }
        .onKeyboardShortcut(.globalCommitPanel, type: .keyDown, perform: {
            self.showPanel.toggle()
        })
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
        // .task {
        //     print("\(passwords.debugDescription)")
        //     if passwords == nil || passwords?.values.isEmpty == true {
        //         showOnboarding = true
        //     }
        // }
        // .sheet(isPresented: $showOnboarding) {
        //     OnboardingWindow()
        // }
    }
}
