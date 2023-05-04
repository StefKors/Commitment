//
//  HotKeyAccentBorderGroupBoxStyle.swift
//  Commitment
//
//  Created by Stef Kors on 16/01/2023.
//

import SwiftUI

struct HotKeyAccentBorderGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        GroupBox(configuration)
            .background(.background.opacity(0.8))
            // .background(.background)
            .clipShape(ContainerRelativeShape())
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .border(Color.accentColor, width: 1, cornerRadius: 6)
            .buttonStyle(.borderedProminent)
            .shadow(radius: 10)
    }
}

struct HotKeyAccentBorderGroupBoxStyle_Previews: PreviewProvider {
    static var previews: some View {
        GroupBox {
            Text("Content")
                .font(.title)
                .scenePadding()
        }.scenePadding()
    }
}
