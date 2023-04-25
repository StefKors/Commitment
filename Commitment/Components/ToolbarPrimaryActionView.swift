//
//  ToolbarPrimaryActionView.swift
//  Commitment
//
//  Created by Stef Kors on 25/02/2023.
//

import SwiftUI

struct ToolbarPrimaryActionView: View {
    @EnvironmentObject private var repo: RepoState

    var body: some View {

        if repo.commitsAhead.count > 0 {
            ToolbarPushOriginActionButtonView(workspace: repo.shell.workspace)
        } else {
            ToolbarFetchOriginActionView(workspace: repo.shell.workspace)
        }
    }
}

struct ToolbarPrimaryActionView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarPrimaryActionView()
    }
}
