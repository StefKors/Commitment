//
//  WelcomeRepoListView.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI

struct WelcomeRepoListView: View {
    @EnvironmentObject private var state: WindowState
    @Environment(\.openWindow) private var openWindow

    var body: some View {

        VStack(alignment: .leading, spacing: 0) {
            if !state.repos.isEmpty {

                ForEach(state.repos.suffix(5), id: \.id) { repo in
                    ListItem(
                        label: repo.folderName,
                        subLabel: repo.branch,
                        assetImage: "git-repo-24"
                    ).onTapGesture {
                        print("opening repo \(repo.folderName)")
                        openWindow(value: repo)
                    }
                }

            } else {
                ListItem(
                    label: "Learn Git",
                    subLabel: "Getting started with Git",
                    systemImage: "graduationcap"
                )

                ListItem(
                    label: "Release Notes",
                    subLabel: "Learn about new features",
                    systemImage: "newspaper"
                )
            }

            ListItem(
                label: "Add Local Repository",
                subLabel: "Click here",
                systemImage: "plus.rectangle.on.folder.fill"
            ).onTapGesture {
                if let selectedRepo = state.openRepo() {
                    print("opening repo \(selectedRepo.folderName)")
                    openWindow(value: selectedRepo)
                }
            }
        }
    }
}

struct ListItem: View {
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
        WelcomeRepoListView()
    }
}
