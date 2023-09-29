//
//  WelcomeRepoListView.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI

struct WelcomeRepoListView: View {
    @EnvironmentObject private var appModel: AppModel
    let repos: [CodeRepository]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !repos.isEmpty {
                ForEach(repos, id: \.id) { repo in
                    WelcomeListItem(
                        label: repo.folderName,
                        subLabel: repo.branch?.name.localName ?? "",
                        assetImage: "git-repo-24"
                    ).onTapGesture {
                        print("TODO: implement open window")
//                        appModel.$activeRepositoryId.set(repo.id)
                    }
                }

            } else {
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
            }

            WelcomeListItem(
                label: "Add Local Repository",
                subLabel: "Click here",
                systemImage: "plus.rectangle.on.folder.fill"
            ).onTapGesture {
                appModel.openRepo()
            }
        }
//        .onReceive(appModel.$repos.$items, perform: {
            // Filtering can happen here
//            self.repos = $0.suffix(5)
//        })
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
        WelcomeRepoListView(repos: [])
    }
}
