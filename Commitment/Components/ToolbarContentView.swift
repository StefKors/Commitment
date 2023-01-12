//
//  ToolbarContentView.swift
//  Commitment
//
//  Created by Stef Kors on 11/01/2023.
//

import SwiftUI

struct ToolbarContentView: View {
    var body: some View {
        GroupBox {
            HStack {
                RepoSelectView()
                Image(systemName: "chevron.compact.right")
                RepoSelectView()
                Image(systemName: "chevron.compact.right")
                RepoSelectView()
            }
        }
    }
}

struct ToolbarContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarContentView()
    }
}
