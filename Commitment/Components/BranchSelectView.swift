//
//  BranchSelectView.swift
//  Commitment
//
//  Created by Stef Kors on 13/01/2023.
//

import SwiftUI

struct BranchSelectButtonView: View {
    @EnvironmentObject private var repo: RepoState

    var body: some View {
        HStack {
            Image("git-branch-16")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
                .foregroundColor(.primary)
            VStack(alignment: .leading) {
                Text("Current Branch")
                    .foregroundColor(.secondary)
                Text(self.repo.branch)
                    .foregroundColor(.primary)
            }
        }
    }
}

struct BranchSelectView: View {
    @EnvironmentObject private var repo: RepoState
    var placeholder = "Select Branch"
    @State private var searchText: String = ""
    @State private var isPresented: Bool = false
    var filteredRepos: [GitReference] {
        if searchText.isEmpty {
            return self.repo.branches
        } else {
            return self.repo.branches.filter({ branch in
                branch.name.localName.localizedCaseInsensitiveContains(searchText)
            })
        }
    }

    var body: some View {

        BranchSelectButtonView()
            .contentShape(Rectangle())
            .onTapGesture {
                isPresented = true
            }
            .popover(isPresented: $isPresented, attachmentAnchor: .point(.bottom), arrowEdge: .bottom, content: {
                VStack(spacing: 0) {
                    TextField("Branch Search", text: $searchText, prompt: Text("Filter"))
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

                    ForEach(repo.branches) { branch in
                        Button(action: {
                            Task(priority: .userInitiated, operation: { @MainActor in
                                do {
                                    let name = branch.name.fullName
                                    print("checkout branch \(name)")
                                    try await repo.shell.checkout(name)
                                } catch {
                                    print(error.localizedDescription)
                                }
                                try await repo.refreshRepoState()
                            })
                        }, label: {
                            HStack {
                                Image("git-branch-16")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.primary)
                                Text(branch.name.localName)
                                Spacer()
                            }
                        })
                        .buttonStyle(.toolbarMenuButtonStyle)
                    }
                }
                .truncationMode(.tail)
                .frame(maxWidth: 300)
                .padding(.vertical, 4)
                .padding(.horizontal, 4)
            })
    }

    func createBranch() {
        print("TODO: create branch")
    }
}

struct BranchSelectView_Previews: PreviewProvider {
    static var previews: some View {
        BranchSelectView()
    }
}
