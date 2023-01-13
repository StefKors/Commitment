//
//  BranchView.swift
//  Commitment
//
//  Created by Stef Kors on 06/04/2022.
//

import SwiftUI

struct BranchView: View {
    var branch: String
    var body: some View {
        HStack(spacing: 0) {
            Image("git-branch-16")
                .resizable()
                .frame(width: 16, height: 16)
            Text(branch)
                .navigationSubtitle(branch)
        }
    }
}

struct BranchView_Previews: PreviewProvider {
    static var previews: some View {
        BranchView(branch: "stef/commitment-launch")
    }
}
