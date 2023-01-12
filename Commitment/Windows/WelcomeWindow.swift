//
//  WelcomeWindow.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI

struct WelcomeWindow: View {
    var body: some View {
        HStack(alignment: .top, spacing: 50) {
            WelcomeStackView()
            // WelcomeRepoListView()
        }.padding()
    }
}

struct WelcomeWindow_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeWindow()
    }
}
