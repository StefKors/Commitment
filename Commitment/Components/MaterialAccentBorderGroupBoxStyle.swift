//
//  MaterialAccentBorderGroupBoxStyle.swift
//  Commitment
//
//  Created by Stef Kors on 23/02/2023.
//

import SwiftUI

struct MaterialAccentBorderGroupBoxStyle: GroupBoxStyle {
    var isActive: Bool
    func makeBody(configuration: Configuration) -> some View {
        let accent = isActive ? Color.accentColor : Color.clear
        let accentDisabled: Double = isActive ? 0 : 1
        GroupBox(configuration)
            .background(.background.opacity(0.1))
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .border(accent, width: 1, cornerRadius: 6)
            .buttonStyle(.borderedProminent)
            .foregroundColor(.primary)
            .animation(.easeIn(duration: 0.1), value: accent)
    }
}

struct MaterialAccentBorderGroupBoxStyle_Previews: PreviewProvider {
    static var previews: some View {
        GroupBox {
            Text("Content")
                .font(.title)
                .scenePadding()
        }.scenePadding()
    }
}
