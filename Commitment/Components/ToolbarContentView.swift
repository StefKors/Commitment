//
//  ToolbarContentView.swift
//  Commitment
//
//  Created by Stef Kors on 11/01/2023.
//

import SwiftUI

struct ToolbarContentView: View {
    @EnvironmentObject var repo: RepoState

    var body: some View {
        GroupBox {
            HStack {
                RepoSelectView()
                Image(systemName: "chevron.compact.right")
                BranchView(branch: repo.branch)
                Image(systemName: "chevron.compact.right")
                DiffSummaryView()
            }
        }
    }
}

struct ToolbarContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarContentView()
    }
}
