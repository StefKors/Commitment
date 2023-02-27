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
    @State private var searchText: String = ""
    
    var body: some View {

        CustomMenu {
            HStack {
                TextField("Repo Search", text: $searchText, prompt: Text("Filter"))
                    .textFieldStyle(.roundedBorder)
                    .font(.body)

                Button("Create Branch", action: {
                    // TODO:
                })
                .buttonStyle(.bordered)
            }
            .padding(.bottom)

            ForEach(repo.branches.indices, id: \.self){ index in
                Button(action: {
                    Task(priority: .userInitiated, operation: {
                        print("checkout branch \(repo.branches[index].name.localName)")
                        do {
                            // try await repo.shell.checkout(repo.branches[index].name.fullName)
                        } catch {
                            print(error.localizedDescription)
                        }
                        repo.refreshRepoState()
                    })
                }, label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(repo.branches[index].name.localName)
                        }
                        Spacer()
                    }
                })
            }
        } label: {
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

    func createBranch() {
        print("TODO: create branch")
    }
}

struct BranchSelectView_Previews: PreviewProvider {
    static var previews: some View {
        BranchSelectView()
    }
}
