//
//  TouchbarContentView.swift
//  Commitment
//
//  Created by Stef Kors on 04/02/2023.
//

import SwiftUI

struct TouchbarContentView: View {
    @EnvironmentObject private var repo: RepoState

    var body: some View {
        HStack {
            Label(self.repo.folderName, image: "git-repo-16")
            Image(systemName: "chevron.compact.right")

            if !self.repo.branch.isEmpty {
                Label(self.repo.branch, image: "git-branch-16")
                Image(systemName: "chevron.compact.right")
            }

            TouchbarActiveChangesStatsView(showBlocks: true)
        }
        .touchBarItemPresence(.required("stefkors.commitment.requiredtoolbaritems"))
    }
}

struct TouchbarContentView_Previews: PreviewProvider {
    static var previews: some View {
        TouchbarContentView()
    }
}
