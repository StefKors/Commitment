//
//  RepoSelectView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI
import AppKit

struct RepoSelectMenuButton: View {
    @EnvironmentObject private var repo: RepoState

    var body: some View {
        HStack {
            Image("git-repo-16")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
                .foregroundColor(.primary)
            VStack(alignment: .leading) {
                Text("Current Repository")
                    .opacity(0.7)
                Text(self.repo.folderName)
            }
        }
    }
}

struct RepoSelectView: View {
    @EnvironmentObject private var repo: RepoState
    @EnvironmentObject var appModel: AppModel
    @State private var repos: [RepoState] = []
    var filteredRepos: [RepoState] {
        if searchText.isEmpty {
            return self.repos
        } else {
            return self.repos.filter({ repo in
                repo.folderName.localizedCaseInsensitiveContains(searchText)
            })
        }
    }
    @State private var searchText: String = ""
    @State private var isPresented: Bool = false
    var placeholder = "Select Repo"

    var body: some View {
        RepoSelectMenuButton()
            .contentShape(Rectangle())
            .onTapGesture {
                isPresented.toggle()
            }
            .popover(isPresented: $isPresented, attachmentAnchor: .point(.bottom), arrowEdge: .bottom, content: {
                VStack(spacing: 0) {
                    TextField("Repo Search", text: $searchText, prompt: Text("Filter"))
                        .textFieldStyle(.roundedBorder)
                        .font(.body)
                        .overlay(alignment: .trailing) {
                            if !searchText.isEmpty {
                                Button(action: {
                                    self.searchText = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.secondary)
                                        .padding(.trailing, 4)
                                }.buttonStyle(.plain)
                            }
                        }

                    ForEach(filteredRepos) { repo in
                        Button(action: {
                            appModel.$activeRepositoryId.set(repo.id)
                            isPresented = false
                            Task {
                                try? await repo.refreshRepoState()
                            }
                        }, label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(repo.folderName)
                                        if let date = repo.lastFetchedDate {
                                            Spacer()
                                            Text(date, format: .relative(presentation: .named))
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    Text(repo.branch)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                        })
                        .buttonStyle(.customButtonStyle)
                    }
                }
                .truncationMode(.tail)
                .frame(maxWidth: 300)
                .padding(.vertical, 4)
                .padding(.horizontal, 4)
            })
            .onReceive(appModel.$repos.$items, perform: {
                // Filtering can happen here
                self.repos = $0
            })
    }
}

struct RepoSelectView_Previews: PreviewProvider {
    static var previews: some View {
        RepoSelectView()
    }
}
