//
//  WelcomeStackView.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI

struct WelcomeStackView: View {
    private var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

    private var appBuild: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }

    var body: some View {
        VStack(spacing: 10) {
            AppIcon()
                .padding(.bottom)

            HStack {
                Text("Welcome to ") +
                Text("Difference")
                    .foregroundColor(Color.accentColor)
            }
            .font(.largeTitle)
            .fontWeight(.black)
            .fixedSize(horizontal: true, vertical: false)

            HStack {
                PillView(label: "Build: \(appBuild)")
                PillView(label: "Version: \(appVersion)")
            }
        }
    }
}

struct WelcomeStackView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeStackView()
    }
}
