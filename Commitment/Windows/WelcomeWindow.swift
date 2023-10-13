//
//  WelcomeWindow.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI

struct WelcomeContentView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 50) {
            WelcomeStackView()
            WelcomeRepoListView()
        }
        .padding()
        .padding(.leading)
    }
}

struct WelcomeWindow_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeContentView()
    }
}
