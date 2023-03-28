//
//  TouchbarContentView.swift
//  Commitment
//
//  Created by Stef Kors on 04/02/2023.
//

import SwiftUI

struct TouchbarContentView: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                RepoSelectView()
                Image(systemName: "chevron.compact.right")
                BranchSelectView()
                // Image(systemName: "chevron.compact.right")
                // DiffSummaryView()
            }
        }
    }
}

struct TouchbarContentView_Previews: PreviewProvider {
    static var previews: some View {
        TouchbarContentView()
    }
}
