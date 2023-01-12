//
//  RepoSelectView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI

struct RepoSelectView: View {
    @EnvironmentObject private var model: RepositoriesModel
    @EnvironmentObject private var state: WindowState

    var placeholder = "Select Repo"

    var body: some View {
        Menu {
            ForEach(model.repos.indices, id: \.self){ index in
                Button(action: {
                    self.state.repo = model.repos[index]
                }, label: {
                    Text(model.repos[index].folderName)
                })
            }
        } label: {
            HStack {
                Image(systemName: "folder")
                Text(self.state.repo.folderName)
                    .foregroundColor(.primary)
            }
                .font(.system(size: 11))
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
    }
}

struct RepoSelectView_Previews: PreviewProvider {
    static var previews: some View {
        RepoSelectView()
    }
}
