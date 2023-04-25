//
//  OnboardingWindow.swift
//  Commitment
//
//  Created by Stef Kors on 25/04/2023.
//

import SwiftUI

struct OnboardingWindow: View {
    @Environment(\.openWindow) var openWindow

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Credentials")
                    .fontWeight(.semibold)
                Text("Authenticate with remote git servers by importing your .git-config file.")
                    .foregroundStyle(.secondary)
                Button {
                    openWindow(id: "settings")
                } label: {
                    SettingsListItemView(tag: .Credentials, image: "key.fill", fill: .gray.darker(by: 30))
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 6)
                .buttonStyle(.plain)
                .background {
                    RoundedRectangle(cornerRadius: 6).fill(.secondary).opacity(0.4)
                }
                // .background(Color.accentColor)
            }
        }
        .scenePadding()
    }
}

struct OnboardingWindow_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingWindow()
    }
}
