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

        if repo.commitsAhead > 0 {
            ToolbarPushOriginActionButtonView()
        } else {
            ToolbarRefresh
        }
    }
}

struct ToolbarPrimaryActionView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarPrimaryActionView()
    }
}
