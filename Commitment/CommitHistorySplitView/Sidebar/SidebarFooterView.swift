//
//  SidebarFooterView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI

struct SidebarFooterView: View {
    var body: some View {
        VStack(alignment: .trailing) {
            AddRepoView()
                .padding(5)
        }
        .background(.background)
        .cornerRadius(8)
        .padding()
    }
}

struct SidebarFooterView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarFooterView()
    }
}
