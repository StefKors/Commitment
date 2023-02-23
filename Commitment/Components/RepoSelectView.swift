//
//  RepoSelectView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI

struct RepoSelectView: View {
    @EnvironmentObject private var repo: RepoState
    @EnvironmentObject var appModel: AppModel
    @State private var repos: [RepoState] = []
    @State private var searchText: String = ""
    var placeholder = "Select Repo"

    var body: some View {
        CustomMenu {
            TextField("Repo Search", text: $searchText, prompt: Text("Filter"))
                .textFieldStyle(.roundedBorder)
                .font(.body)

            ForEach(repos.indices, id: \.self){ index in
                Button(action: {
                    appModel.$activeRepositoryId.set(repos[index].id)
                }, label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(repos[index].folderName)
                            Text(repos[index].branch)
                                .opacity(0.7)
                        }
                        Spacer()
                    }
                })
            }
        } label: {
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
        .onReceive(appModel.$repos.$items, perform: {
            // Filtering can happen here
            self.repos = $0.suffix(5)
        })
    }
}

struct RepoSelectView_Previews: PreviewProvider {
    static var previews: some View {
        RepoSelectView()
    }
}
