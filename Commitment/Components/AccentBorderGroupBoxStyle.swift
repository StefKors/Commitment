//
//  AccentBorderGroupBoxStyle.swift
//  Commitment
//
//  Created by Stef Kors on 16/01/2023.
//

import SwiftUI

struct AccentBorderGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        GroupBox(configuration)
            .background(Color.accentColor.opacity(0.1))
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .border(Color.accentColor, width: 1, cornerRadius: 6)
            .buttonStyle(.borderedProminent)
    }
}

struct AccentBorderGroupBoxStyle_Previews: PreviewProvider {
    static var previews: some View {
        GroupBox {
            Text("Content")
                .font(.title)
                .scenePadding()
        }.scenePadding()
    }
}
