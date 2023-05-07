//
//  TouchbarRepoView.swift
//  Commitment
//
//  Created by Stef Kors on 07/05/2023.
//

import SwiftUI

struct TouchbarRepoView: View {
    @EnvironmentObject private var repo: RepoState

    var body: some View {
        Label(self.repo.folderName, image: "git-repo-16")
    }
}

struct TouchbarRepoView_Previews: PreviewProvider {
    static var previews: some View {
        TouchbarRepoView()
    }
}
