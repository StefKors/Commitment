//
//  ToolbarContentView.swift
//  Commitment
//
//  Created by Stef Kors on 11/01/2023.
//

import SwiftUI

struct ToolbarContentView: View {
    var body: some View {
        RepoSelectView()
        Image(systemName: "chevron.compact.right")
        BranchSelectView()
        Image(systemName: "chevron.compact.right")
        DiffSummaryView()
    }
}

struct ToolbarContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarContentView()
    }
}
