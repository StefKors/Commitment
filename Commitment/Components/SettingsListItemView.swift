//
//  SettingsListItemView.swift
//  Commitment
//
//  Created by Stef Kors on 01/03/2023.
//

import SwiftUI

struct SettingsListItemView: View {
    @Environment(\.colorScheme) private var colorScheme
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
                    LinearGradient(colors: [
                        fill.lighter(by: 20),
                        fill
                    ], startPoint: .top, endPoint: .bottom)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    // .fill(fill)
                    .shadow(color: colorScheme == .dark ? Color.gray : .black.opacity(0.7), radius: 2, y: 1)
                    .border(fill.darker(by: 10), width: 1, cornerRadius: 6)
                }
                .padding(.leading, 4)

            Text(tag.rawValue)
        }
        .padding(.vertical, 1)
        .tag(tag)
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
