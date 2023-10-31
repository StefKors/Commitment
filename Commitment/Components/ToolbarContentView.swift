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
        VStack(spacing: 0) {

            HStack(alignment: .center, spacing: 10) {
                Group {
                    RepoSelectView()
                    Divider()
                    BranchSelectView()
                    Divider()
                    ToolbarPrimaryActionView()
                    Divider()
                    ToolbarActionUpdateMain()
                    Divider()
                }

                Spacer()

                DiffModeToggleView()
            }
            .frame(height: 50)
            .padding(.horizontal, 10)
            .truncationMode(.head)
            .lineLimit(1)
            .zIndex(999)

            Divider()
        }
    }
}

struct ToolbarContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarContentView()
    }
}
