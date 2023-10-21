//
//  ContentView.swift
//  Commitment
//
//  Created by Stef Kors on 14/10/2023.
//  based-on: https://developer.apple.com/documentation/swiftdata/filtering-and-sorting-persistent-data

import SwiftUI
import SwiftData

struct ContentView: View {
    @Binding var repositoryID: URL?

    @Query private var repositories: [CodeRepository]
    @State private var activeRepository: CodeRepository?

    var body: some View {
        Group {
            if let activeRepository {
                RepositoryWindow()
                    .environment(activeRepository)
                    .frame(minWidth: 1100, minHeight: 600)
            } else {
                WelcomeContentView()
                    .environment(\.activeRepositoryID, $repositoryID)
                    .frame(width: 700, height: 300, alignment: .center)
            }
        }
        .task(id: repositoryID) {
            self.activeRepository = repositories.first { repo in
                repo.path == repositoryID
            }
        }
        .onOpenURL(perform: { url in
            repositoryID = url
        })
    }
}
