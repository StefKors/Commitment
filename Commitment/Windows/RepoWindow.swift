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
    static let productUserActivityType = "com.stefkors.Difference.repoview"

    @EnvironmentObject var state: WindowState

    var body: some View {
        HStack {
            // Watch out for re-renders, can be slow
            if let repo = state.repo.repository, let allCommits = try? repo.listLogRecords().records {
                CommitHistorySplitView(allCommits: allCommits)
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
        }
        .frame(minWidth: 400, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
        .navigationTitle(state.repo.folderName)
        .navigationSubtitle(state.repo.branch?.name.localName ?? "no-branch")
    }
}
