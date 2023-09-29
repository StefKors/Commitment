//
//  ContentView.swift
//  Commitment
//
//  Created by Stef Kors on 19/07/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var appModel: AppModel
    @Query private var repositories: [CodeRepository]
    @State private var isPresented: Bool = false

    @Environment(\.dismiss) private var dismiss
    private let appVersion: String = "Build: \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")"
    private let appBuild: String = "Version: \(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "")"

    var body: some View {
        VStack(spacing: 10) {
            AppIcon()
                .padding(.bottom)

            HStack {
                Text("Welcome to ") +
                Text("Commitment")
                    .foregroundColor(Color.accentColor)
            }
            .font(.largeTitle)
            .fontWeight(.black)
            .fixedSize(horizontal: true, vertical: false)

            HStack {
                PillView(label: appBuild)
                PillView(label: appVersion)
            }

            VStack {
                if repositories.isEmpty {
                    Text("empty array")
                }
                ForEach(repositories) { repo in
                    Text(repo.path.description)
                }

            }

            WelcomeListItem(
                label: "Add Local Repository",
                subLabel: "Click here",
                systemImage: "plus.rectangle.on.folder.fill"
            ).onTapGesture {
//                appModel.openRepo()
                isPresented.toggle()
                dismiss()
            }
            .padding(.top, 30)
        }
        .fileImporter(
            isPresented: $isPresented,
            allowedContentTypes: [.directory]
        ) { result in
            switch result {
            case .success(let directory):
                // gain access to the directory
                let gotAccess = directory.startAccessingSecurityScopedResource()
                if !gotAccess { return }
                self.appModel.bookmarks.storeFolderInBookmark(url: directory)
                addItem(url: directory)
                // access the directory URL
                // (read templates in the directory, make a bookmark, etc.)
//                onTemplatesDirectoryPicked(directory)
                // release access
                directory.stopAccessingSecurityScopedResource()
            case .failure(let error):
                // handle error
                print(error)
            }
        }
    }

    private func addItem(url: URL) {
        withAnimation {
            let newRepository = CodeRepository(path: url)
            modelContext.insert(newRepository)
        }
    }

    // private func deleteItems(offsets: IndexSet) {
    //     withAnimation {
    //         for index in offsets {
    //             modelContext.delete(recordings[index])
    //         }
    //     }
    // }
}

#Preview {
    ContentView()
}
