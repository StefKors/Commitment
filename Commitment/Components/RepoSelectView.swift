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
    var placeholder = "Select Repo"

    var body: some View {
        Menu {
            ForEach(repos.indices, id: \.self){ index in
                Button(action: {
                    appModel.$activeRepositoryId.set(repos[index].id)
                }, label: {
                    Text(repos[index].folderName)
                })
            }
        } label: {
            HStack {
                Image("git-repo-16")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                    .foregroundColor(.primary)
                Text(self.repo.folderName)
                    .foregroundColor(.primary)
            }
            .font(.system(size: 11))
        }
        .menuStyle(.borderlessButton)
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
