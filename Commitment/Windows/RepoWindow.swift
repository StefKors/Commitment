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

    @EnvironmentObject var repo: RepoState

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
        .navigationTitle(repo.folderName ?? "Commitment")
        .navigationSubtitle(repo.branch?.name.localName ?? "no-branch")
    }
}
