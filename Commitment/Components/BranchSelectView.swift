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
                .foregroundStyle(.primary)
            VStack(alignment: .leading) {
                Text("Current Branch")
                    .foregroundStyle(.secondary)
                Text(self.repo.branch)
                    .foregroundStyle(.primary)
            }
        }
    }
}

struct BranchSelectView: View {
    @EnvironmentObject var model: AppModel
    @EnvironmentObject private var repo: RepoState
    var placeholder = "Select Branch"
    @State private var searchText: String = ""
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
                model.isBranchSelectOpen.toggle()
            }
            .overlay(isPresented: $model.isBranchSelectOpen, alignment: .topLeading, relativePos: .bottomLeading, extendHorizontally: true) {
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
                                        .foregroundStyle(.secondary)
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
                                    .foregroundStyle(.primary)
                                Text(branch.name.localName)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Text(branch.date, format: .relative(presentation: .named))
                                    .foregroundStyle(.secondary)
                            }
                        })
                        .buttonStyle(.toolbarMenuButtonStyle)
                    }
                }
                .truncationMode(.tail)
                .frame(maxWidth: 300)
                .padding(.vertical, 4)
                .padding(.horizontal, 4)
                .background(.ultraThinMaterial)
                .cornerRadius(6)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(.separator, lineWidth: 1))
                .shadow(radius: 15)
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
