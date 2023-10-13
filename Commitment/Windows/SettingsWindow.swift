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
        case SSH = "SSH Keys"
        case KeyboardShortcuts = "Keyboard Shortcuts"
        case Beta = "Beta Features"
    }

    @State private var selectedMenu: Tabs = .General
    // TODO: Implement Searchable
    // @State private var searchText: String = ""

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedMenu) {
                SettingsListItemView(tag: .General, image: "gear", fill: .gray)
                SettingsListItemView(tag: .Credentials, image: "key.fill", fill: .gray.darker(by: 30))
                SettingsListItemView(tag: .SSH, image: "lock.doc", fill: .orange)
                SettingsListItemView(tag: .KeyboardShortcuts, image: "keyboard", fill: .green.darker())
                SettingsListItemView(tag: .Beta, image: "testtube.2", fill: .blue)
            }
            .listStyle(.sidebar)
            // .frame(maxWidth: 200)
            .navigationSplitViewColumnWidth(215)
            // TODO: Implement Searchable
            // .safeAreaInset(edge: .top, spacing: 0) {
            //     List {}
            //         .frame(height: 35)
            //         .searchable(text: $searchText, placement: .sidebar, prompt: "Search")
            //         .scrollDisabled(true)
            // }


        } detail: {
            Form {
                switch selectedMenu {
                case .General:
                    GeneralSettingsView()
                case .Credentials:
                    CredentialSettingsView()
                case .KeyboardShortcuts:
                    KeyboardShortcutsSettingsView()
                case .SSH:
                    Text("todo")
//                    SSHKeysSettingsView()
                case .Beta:
                    BetaSettingsView()
                }
            }
            .formStyle(.grouped)
            .animation(.easeInOut(duration: 0.2), value: selectedMenu)
            .navigationTitle(selectedMenu.rawValue)
            .hideSidebarToggle()
        }
    }
}

struct SettingsWindow_Previews: PreviewProvider {
    static var previews: some View {
        SettingsWindow()
    }
}
