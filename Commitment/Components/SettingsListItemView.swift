//
//  SettingsListItemView.swift
//  Commitment
//
//  Created by Stef Kors on 01/03/2023.
//

import SwiftUI

struct SettingsListItemView: View {
    let tag: SettingsWindow.Tabs
    let image: String
    let fill: Color
    var body: some View {
        HStack {
            Image(systemName: image)
                .foregroundColor(.white)
                .imageScale(.small)
                .fontWeight(.bold)
                .frame(width: 20, height: 20, alignment: .center)
                .background {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(fill)
                        .shadow(radius: 2)

                }
                .padding(.leading, 3)

            Text(tag.rawValue.capitalized)
        }.tag(tag)
    }
}

struct SettingsListItemView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SettingsListItemView(tag: .General, image: "slider.horizontal.3", fill: .pink)
            SettingsListItemView(tag: .General, image: "gear", fill: .gray)
            SettingsListItemView(tag: .Credentials, image: "key.fill", fill: .black)
        }
    }
}
