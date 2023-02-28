//
//  SettingsWindow.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI

struct SettingsWindow: View {
    private enum Tabs: Hashable {
        case general, advanced, credentials
    }

    @State private var selectedMenu: Tabs = .general

    var body: some View {
        HStack(spacing: 0) {
            List(selection: $selectedMenu) {
                HStack {
                    Image(systemName: "slider.horizontal.3")
                        .imageScale(.small)
                        .fontWeight(.bold)
                        .padding(4)
                        .frame(width: 20, height: 20, alignment: .center)
                        .background {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(.blue)
                                .shadow(radius: 2)
                        }

                    Text("Editor Defaults")
                }.tag(Tabs.general)

                HStack {
                    Image(systemName: "key.fill")
                        .imageScale(.small)
                        .fontWeight(.bold)
                        .padding(4)
                        .frame(width: 20, height: 20, alignment: .center)
                        .background {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(.black)
                                .shadow(radius: 2)
                        }

                    Text("Credentials")
                }.tag(Tabs.credentials)
            }
            .listStyle(.sidebar)
            .frame(maxWidth: 200)

            Divider()

            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 12) {
                    GeneralSettingsView()
                    AdvancedSettingsView()
                }.padding()
            }
        }
    }
}

struct SettingsWindow_Previews: PreviewProvider {
    static var previews: some View {
        SettingsWindow()
    }
}
