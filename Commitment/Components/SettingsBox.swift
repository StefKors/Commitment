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
    let sublabel: String

    /// Creates a SettingsBox with custom content and label.
    init(label: String, sublabel: String, @ViewBuilder content: () -> Content) {
        self.ContainerContent = content()
        self.label = label
        self.sublabel = sublabel
    }

    var body: some View {
        GroupBox(content: {
            VStack {
                ContainerContent
            }.padding(6)
        }, label: {
            // Text("Credentials")
            VStack(alignment: .leading) {
                Text(label)
                    .labelStyle(.titleOnly)
                    .font(.title3)
                    .fontWeight(.semibold)

                Text(sublabel)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 6)
        })
    }
}

struct SettingsBox_Previews: PreviewProvider {
    static var previews: some View {
        SettingsBox(
            label: "Account Credentials",
            sublabel: "Your git credentials can be parsed and imported from an .git-credentials file. Click import to get started."
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
