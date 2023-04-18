//
//  CommitHotKeyWindow.swift
//  Commitment
//
//  Created by Stef Kors on 27/03/2023.
//

import SwiftUI
import Boutique
import WindowManagement
// Inspo:
// https://twitter.com/RobSwish/status/1648109017867206657
// https://reichel.dev/blog/swift-global-key-binding.html#install-hotkey
struct CommitHotKeyWindow: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.window) private var window
    @EnvironmentObject private var appModel: AppModel
    @StateObject var viewState = ViewState()

    @State private var repo: RepoState? = nil

    let id: RepoState.ID?

    var body: some View {
        VStack {
            if let repo {
                NavigationView {
                    HotKeyActiveChangesSidebarView(selection: $viewState.activeChangesSelection)

                    HotKeyActiveChangesMainView(id: viewState.activeChangesSelection)
                        .ignoresSafeArea(.all, edges: .top)
                        .frame(minWidth: 300)
                }
                // .frame(minWidth: 600, minHeight: 400)
                // .transition(
                //     .scale(scale: 0).animation(.linear(duration: 0.3))
                //     .combined(with: .opacity.animation(.easeInOut(duration: 1.3)))
                // )
                .environmentObject(repo)
            }
        }
        .task {
            guard let id, let key = URL(string: id) else { return }
            let repo = appModel.repos.first(with: CacheKey(url: key).value)
            guard let repo else { return }
            self.repo = repo
            // Move to after refreshRepoState?
            getDefaultItem()

            Task {
                do {
                    try await repo.refreshRepoState()
                } catch {
                    print(error.localizedDescription)
                }
            }
            repo.startMonitor()
        }
    }

    func getDefaultItem() {
        guard let defaultItem = self.repo?.status.first?.id else { return }
        if viewState.activeChangesSelection == nil {
            viewState.activeChangesSelection = defaultItem
        }
    }
}

struct CommitHotKeyWindow_Previews: PreviewProvider {
    static var previews: some View {
        CommitHotKeyWindow(id: nil)
    }
}
