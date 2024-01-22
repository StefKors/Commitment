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
        //            .overlay(isPresented: $viewState.isRepoSelectOpen, alignment: .topLeading, relativePos: .bottomLeading, extendHorizontally: true) {
        // not sure why arrow edge is set at bottom here
            .popover(isPresented: $isRepoSelectOpen, attachmentAnchor: .point(UnitPoint.bottom), arrowEdge: .bottom, content: {
                
                List {
                    ForEach(repos, id: \.id) { repo in
                        Button(action: {
                            openRepository(repo)
                        }, label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(repo.folderName)
                                            .foregroundStyle(.primary)
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
