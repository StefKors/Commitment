//
//  ToolbarContentView.swift
//  Commitment
//
//  Created by Stef Kors on 11/01/2023.
//

import SwiftUI

struct ToolbarContentView: View {
    var body: some View {
        HStack {
            ToolbarActionButtonView()
            ToolbarActionUpdateMain()
            Spacer()
        }
        .padding(.top, 6)
        .padding(.horizontal, 6)
    }
}

struct ToolbarContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarContentView()
    }
}
