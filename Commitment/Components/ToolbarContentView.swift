//
//  ToolbarContentView.swift
//  Commitment
//
//  Created by Stef Kors on 11/01/2023.
//

import SwiftUI

struct ToolbarContentView: View {
    /// TODO: Handle line wrapping
    /// TODO: Handle view that fits
    /// TODO: improve menu...
    /// TODO: Fix blinking when switching view
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Group {
                RepoSelectView()
                Divider()
                BranchSelectView()
                Divider()
                ToolbarPrimaryActionView()
                Divider()
            }

            Group {
                ToolbarActionUpdateMain()
                Divider()
                ToolbarOpenCommitWindowView()
                Divider()
                Spacer()
            }
        }
        .frame(height: 50)
        .padding(.horizontal, 10)
        .truncationMode(.head)
        .lineLimit(1)
    }
}

struct ToolbarContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarContentView()
    }
}
