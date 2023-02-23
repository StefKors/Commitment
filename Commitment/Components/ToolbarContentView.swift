//
//  ToolbarContentView.swift
//  Commitment
//
//  Created by Stef Kors on 11/01/2023.
//

import SwiftUI

struct ToolbarContentView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            RepoSelectView()
            Divider()
            BranchSelectView()
            Divider()
            ToolbarActionButtonView()
            Divider()
            ToolbarActionUpdateMain()
            Divider()
            Spacer()
        }
        .frame(height: 50)
        .padding(.horizontal, 10)
    }
}

struct ToolbarContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarContentView()
    }
}
