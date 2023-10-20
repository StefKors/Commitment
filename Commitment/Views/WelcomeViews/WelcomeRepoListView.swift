//
//  WelcomeRepoListView.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI
import SwiftData
import OSLog

fileprivate let log = Logger(subsystem: "com.stefkors.commitment", category: "WelcomeRepoListView")

struct WelcomeRepoListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.activeRepositoryID) private var repositoryID
    @State private var showFileImporter: Bool = false
    @Query private var repositories: [CodeRepository]

    var body: some View {

        VStack(alignment: .leading, spacing: 0) {
            WelcomeListItem(
                label: "Learn Git",
                subLabel: "Getting started with Git",
                systemImage: "graduationcap"
            )

            WelcomeListItem(
                label: "Release Notes",
                subLabel: "Learn about new features",
                systemImage: "newspaper"
            )

            if !repositories.isEmpty {
                ForEach(repositories, id: \.id) { repo in
                    WelcomeListItem(
                        label: repo.folderName,
                        subLabel: repo.branch?.name.localName ?? "",
                        assetImage: "git-repo-24"
                    ).onTapGesture {
                        open(repo.path)
                    }
                }
            }

            WelcomeListItem(
                label: "Add Local Repository",
                subLabel: "Click here",
                systemImage: "plus.rectangle.on.folder.fill"
            ).onTapGesture {
                showFileImporter.toggle()
            }
            .fileImporter(
                isPresented: $showFileImporter,
                allowedContentTypes: [.directory]
            ) { result in
                switch result {
                case .success(let directory):
                    // gain access to the directory
                    let gotAccess = directory.startAccessingSecurityScopedResource()
                    if !gotAccess {
                        log.error("Failed to start accessing directory \(directory.description)")
                        return
                    }
                    addItem(url: directory)
                    open(directory)
                case .failure(let error):
                    // handle error
                    print(error)
                }
            }
        }
    }

    private func addItem(url: URL) {
        withAnimation {
            do {
                let newRepository = try CodeRepository(path: url)
                modelContext.insert(newRepository)
            } catch {
                print("failed to create code repo due to bookmark")
            }
        }
    }

    private func open(_ url: URL) {
        // TODO: this doesn't work correctly
        repositoryID.wrappedValue = url
    }
}
