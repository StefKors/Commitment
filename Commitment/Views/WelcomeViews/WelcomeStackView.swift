//
//  WelcomeStackView.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI

struct WelcomeStackView: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    private let appVersion: String = "Build: \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")"
    private let appBuild: String = "Version: \(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "")"

    var body: some View {
        VStack(spacing: 10) {
            AppIcon()
                .padding(.bottom)

            HStack {
                Text("Welcome to ") +
                Text("Commitment")
                    .foregroundColor(Color.accentColor)
            }
            .font(.largeTitle)
            .fontWeight(.black)
            .fixedSize(horizontal: true, vertical: false)

            HStack {
                PillView(label: appBuild)
                PillView(label: appVersion)
            }

            ListItem(
                label: "Add Local Repository",
                subLabel: "Click here",
                systemImage: "plus.rectangle.on.folder.fill"
            ).onTapGesture {
                appModel.openRepo()
                dismiss()
            }
            .padding(.top, 30)
        }
    }
}

struct WelcomeStackView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeStackView()
    }
}
