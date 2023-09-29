//
//  WelcomeWindow.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI
import SwiftData

struct WelcomeWindow: View {
    @Query private var repositories: [CodeRepository]

    var body: some View {
        HStack(alignment: .top, spacing: 50) {
            WelcomeStackView()
             WelcomeRepoListView(repos: repositories)
        }.padding()
    }
}

struct WelcomeWindow_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeWindow()
    }
}
