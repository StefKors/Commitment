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
        Text(branch)
            .navigationSubtitle(branch)
    }
}

struct BranchView_Previews: PreviewProvider {
    static var previews: some View {
        BranchView(branch: "stef/commitment-launch")
    }
}
