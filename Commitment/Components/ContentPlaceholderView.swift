//
//  ContentPlaceholderView.swift
//  Commitment
//
//  Created by Stef Kors on 14/01/2023.
//

import SwiftUI

struct ContentPlaceholderView: View {
    @EnvironmentObject private var repo: RepoState
    @AppStorage("SelectedExternalEditor") private var selectedExternalEditor: String = "Visual Studio Code"
    @AppStorage("SelectedExternalGitProvider") private var selectedExternalGitProvider: String = "GitHub"

    var body: some View {
        ScrollView(.vertical) {
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("No local changes")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .fixedSize(horizontal: true, vertical: false)
                        Text("There are no uncommited changes in this repository. Here are some friendly suggestions for what to do next:")
                            .lineSpacing(4)
                    }
                    .frame(minWidth: 400, maxWidth: 600)

                    VStack(alignment: .leading, spacing: 10) {
                        GroupBox {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Publish your repository to \(selectedExternalGitProvider)")
                                        .fontWeight(.semibold)
                                    Text("This repository is currently only available on your local machine. By publishing it on \(selectedExternalGitProvider) you can share it, and collaborate with others.")
                                        .foregroundStyle(.secondary)
                                    HStack {
                                        Text("Always available in the toolbar for local repositories or")
                                        KeyboardKey(key: "⌘")
                                        KeyboardKey(key: "P")
                                    }.foregroundStyle(.secondary)
                                }
                                Spacer()
                                Button("Publish repository", action: {
                                    repo.path.showInFinder()
                                })
                            }
                            .scenePadding()
                        }
                        .groupBoxStyle(AccentBorderGroupBoxStyle())
                        .disabled(true)

                        GroupBox {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Open repository in your external editor")
                                        .fontWeight(.semibold)
                                    HStack {
                                        Text("Repository menu or")
                                        KeyboardKey(key: "⌘")
                                        KeyboardKey(key: "⇧")
                                        KeyboardKey(key: "A")
                                    }.foregroundStyle(.secondary)
                                }
                                Spacer()
                                Button("Open in \(selectedExternalEditor)", action: {
                                    repo.path.showInFinder()
                                })
                            }
                            .scenePadding()
                        }.disabled(true)

                        GroupBox {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("View files of your repository in Finder")
                                        .fontWeight(.semibold)
                                    HStack {
                                        Text("Repository menu or")
                                        KeyboardKey(key: "⌘")
                                        KeyboardKey(key: "⇧")
                                        KeyboardKey(key: "F")
                                    }.foregroundStyle(.secondary)
                                }
                                Spacer()
                                Button("Show in Finder", action: {
                                    repo.path.showInFinder()
                                })
                            }
                            .scenePadding()
                        }
                    }
                    .frame(minWidth: 400, maxWidth: 600)
                }
                .lineLimit(1...6)
                // .frame(width: 650, alignment: .leading)
                .padding()
                Spacer()
            }
        }.scenePadding()
    }
}

// struct ContentPlaceholderView_Previews: PreviewProvider {
//     static let repo = RepoState(string: URL(filePath: "/users/stefkors/Developer/Commitment")!
//     static var previews: some View {
//         ContentPlaceholderView()
//             .environmentObject(repo)
//     }
// }
