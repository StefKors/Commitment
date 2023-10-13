//
//  WelcomeRepoListView.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI
import SwiftData
import WindowManagement

struct WelcomeRepoListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

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
                    if !gotAccess { return }
                    addItem(url: directory)
                    open(directory)

                    //                directory.stopAccessingSecurityScopedResource()
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
        dismissWindow(id: SceneID.welcomeWindow.id)
        NSApp.openWindow(.mainWindow, value: url)
    }
}

struct WelcomeListItem: View {
    var label: String
    var subLabel: String
    var systemImage: String? = nil
    var assetImage: String? = nil

    @State private var isHovering: Bool = false

    var body: some View {
        HStack {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(Font.system(size: 20))
                    .foregroundColor(.accentColor)
                    .frame(width: 25)
            } else if let assetImage {
                Image(assetImage)
                    .font(Font.system(size: 20))
                    .foregroundColor(.accentColor)
                    .frame(width: 25)
            }

            VStack(alignment: .leading) {
                Text(label)
                Text(subLabel)
                    .foregroundColor(.secondary)
                    .truncationMode(.tail)
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.background)
                .shadow(radius: 5)
                .opacity(isHovering ? 1 : 0)
        )
        .offset(y: isHovering ? -3 : 0)
        .animation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0.2), value: isHovering)
        .onHover(perform: { hoverstate in
            isHovering = hoverstate
        })
    }
}


struct WelcomeRepoListView_Previews: PreviewProvider {
    static var previews: some View {
        // TODO: setup previews
        WelcomeRepoListView()
    }
}
