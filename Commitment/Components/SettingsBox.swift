//
//  SettingsBox.swift
//  Commitment
//
//  Created by Stef Kors on 01/03/2023.
//

import SwiftUI

struct SettingsBox<Content: View>: View {
    let ContainerContent: Content
    let label: String

    /// Creates a SettingsBox with custom content and label.
    init(label: String, @ViewBuilder content: () -> Content) {
        self.ContainerContent = content()
        self.label = label
    }

    var body: some View {
        Section {
            ContainerContent
        } header: {
            Text(label)
        }
    }
}

struct SettingsBox_Previews: PreviewProvider {
    static var previews: some View {
        SettingsBox(
            label: "Account Credentials"
            // sublabel: "Your git credentials can be parsed and imported from an .git-credentials file. Click import to get started."
        ) {
            HStack {
                Text("one")
                Spacer()
            }
            HStack {
                Text("two")
                Spacer()
            }
            HStack {
                Text("three")
                Spacer()
            }
        }
        .padding()
    }
}
