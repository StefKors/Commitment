//
//  RepoSelectView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI
import AppKit
import SwiftData
import WindowManagement

struct RepoSelectMenuButton: View {
    @Environment(CodeRepository.self) private var repository

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
                Text( self.repository.folderName)
            }
        }
    }
}

// TODO: do better filtering in the SwiftData query
struct RepoSelectView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(CodeRepository.self) private var repository
    @EnvironmentObject var viewState: ViewState
    @Query private var repos: [CodeRepository]
    @State private var isRepoSelectOpen: Bool = false
    @Environment(\.openURL) private var openURL
    @Environment(\.openRepository) private var openRepository

//    private var filteredRepos: [CodeRepository] {
//        if searchText.isEmpty {
//            return self.repos
//        } else {
//            return self.repos.filter({ repo in
//                repo.folderName.localizedCaseInsensitiveContains(searchText)
//            })
//        }
//    }

    @State private var searchText: String = ""
    var placeholder = "Select Repo"

    var body: some View {
        RepoSelectMenuButton()
            .contentShape(Rectangle())
            .onTapGesture {
                isRepoSelectOpen.toggle()
            }
            // not sure why arrow edge is set at bottom here
            .popover(isPresented: $isRepoSelectOpen, attachmentAnchor: .point(UnitPoint.bottom), arrowEdge: .bottom, content: {
//            .overlay(isPresented: $viewState.isRepoSelectOpen, alignment: .topLeading, relativePos: .bottomLeading, extendHorizontally: true) {
//                VStack(spacing: 0) {
//                    TextField("Repo Search", text: $searchText, prompt: Text("Filter"))
//                        .textFieldStyle(.roundedBorder)
//                        .font(.body)
//                        .overlay(alignment: .trailing) {
//                            if !searchText.isEmpty {
//                                Button(action: {
//                                    self.searchText = ""
//                                }) {
//                                    Image(systemName: "multiply.circle.fill")
//                                        .foregroundColor(.secondary)
//                                        .padding(.trailing, 4)
//                                }.buttonStyle(.plain)
//                            }
//                        }
                    List {
                        ForEach(repos, id: \.id) { repo in
                            Button(action: {
                                // TODO: how to open the current repo instead of creating a new window?
                                print("select repo \(repo.path)")
                                //                            openURL(repo.path)
                                openRepository(repo)

                                //                            NSApp.mainWindow?.close()

                                //                            NSApp.openWindow(SceneID.mainWindow, value: repo.path)
                                //                            viewState.activeRepositoryId = repo.id
                                //                            viewState.isRepoSelectOpen = false
                                //                            Task {
                                //                                try? await repo.refreshRepoState()
                                //                            }
                            }, label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(repo.folderName)
                                                .foregroundStyle(.primary)
                                            //                                        if let date = repo.lastFetchedDate {
                                            //                                            Spacer()
                                            //                                            Text(date, format: .relative(presentation: .named))
                                            //                                                .foregroundStyle(.secondary)
                                            //                                        }
                                        }
                                        Text(repo.branch?.name.localName ?? "")
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                }
                            })
                            .buttonStyle(.toolbarMenuButtonStyle)
                            .contextMenu {
                                Button("Remove Repo") {
                                    removeRepo(repo)
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .truncationMode(.tail)
//                }
//                .frame(width: 300)
//                .padding(.vertical, 4)
//                .padding(.horizontal, 4)
//                .background(.ultraThinMaterial)
//                .cornerRadius(6)
//                .overlay(RoundedRectangle(cornerRadius: 6).stroke(.separator, lineWidth: 1))
//                .shadow(radius: 15)
            })
    }

    private func removeRepo(_ repo: CodeRepository) {
        withAnimation {
            modelContext.delete(repo)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(repos[index])
            }
        }
    }
}

struct RepoSelectView_Previews: PreviewProvider {
    static var previews: some View {
        RepoSelectView()
    }
}
