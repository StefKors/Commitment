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
                    .id(activeRepository.id)
                    .environment(activeRepository)
                    .frame(minWidth: 1100, minHeight: 600)
            } else {
                WelcomeContentView()
                    .frame(width: 700, height: 300, alignment: .center)
            }
        }
        .environment(\.openRepository, OpenRepository({ repo in
            self.activeRepository = repo
        }))
        .task(id: repositoryID) {
            self.activeRepository = repositories.first { repo in
                repo.path == repositoryID
            } ?? repositories.first
        }
        .onOpenURL(perform: { url in
            print("onOpenURL \(url)")
            repositoryID = url
        })
    }
}
