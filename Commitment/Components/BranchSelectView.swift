//
//  BranchSelectView.swift
//  Commitment
//
//  Created by Stef Kors on 13/01/2023.
//

import SwiftUI

struct BranchSelectView: View {
    @EnvironmentObject private var repo: RepoState
    var placeholder = "Select Branch"
    var body: some View {
                Menu {
                    ForEach(repo.branches.indices, id: \.self){ index in
                        Button(action: {
                            // self.repo = state.repos[index]
                            repo.isCheckingOut = true
                            Task(priority: .background, operation: {
                                print("checkout branch \(repo.branches[index].name.localName)")
                                do {
                                    try repo.repository?.checkout(reference: repo.branches[index])
                                } catch {
                                    print(error.localizedDescription)
                                }
                                repo.refreshRepoState()
                            })
                        }, label: {
                            Text(repo.branches[index].name.localName)
                        })
                    }
                } label: {
                    HStack(spacing: 0) {
                        Image("git-branch-16")
                            .resizable()
                            .frame(width: 16, height: 16)
                        Text(repo.branch)
                            .navigationSubtitle(repo.branch)
                    }
                }
                .menuStyle(.borderlessButton)

                Button(action: createBranch, label: {
                    Image(systemName: "plus").imageScale(.small)
                })
                .help("Create Branch")
                .foregroundColor(.primary)
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
