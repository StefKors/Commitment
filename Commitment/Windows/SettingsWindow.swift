//
//  SettingsWindow.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI

struct SettingsWindow: View {
    enum Tabs: String, Hashable {
        case General
        case Credentials
    }

    @State private var selectedMenu: Tabs = .General

    var body: some View {
        HStack(spacing: 0) {
            List(selection: $selectedMenu) {
                SettingsListItemView(tag: .General, image: "gear", fill: .gray)
                SettingsListItemView(tag: .Credentials, image: "key.fill", fill: .black)
            }
            .listStyle(.sidebar)
            .frame(maxWidth: 200)

            Divider()

            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 12) {
                    switch selectedMenu {
                    case .General:
                        GeneralSettingsView()
                    case .Credentials:
                        CredentialSettingsView()
                    }
                }
                .padding()
                .animation(.easeInOut(duration: 0.2), value: selectedMenu)
            }
        }
    }
}

struct SettingsWindow_Previews: PreviewProvider {
    static var previews: some View {
        SettingsWindow()
    }
}
