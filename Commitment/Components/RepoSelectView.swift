//
//  RepoSelectView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI

struct RepoSelectView: View {
    @EnvironmentObject private var repo: RepoState
    @EnvironmentObject private var state: WindowState

    var placeholder = "Select Repo"

    var body: some View {
        Menu {
            ForEach(state.repos.indices, id: \.self){ index in
                Button(action: {
                    self.state.repo = state.repos[index]
                }, label: {
                    Text(state.repos[index].folderName)
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
    }
}

struct RepoSelectView_Previews: PreviewProvider {
    static var previews: some View {
        RepoSelectView()
    }
}
