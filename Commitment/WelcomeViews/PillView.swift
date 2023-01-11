//
//  PillView.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI

struct PillView: View {
    var label: String

    let font = Font
        .system(size: 10)
        .monospaced()

    var body: some View {
        Text(label)
            .foregroundColor(Color.white)
            .font(font)
            .padding(.vertical, 4)
            .padding(.horizontal)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.accentColor)
            )
    }
}

struct PillView_Previews: PreviewProvider {
    static var previews: some View {
        PillView(label: "Version: 16.4.56")
    }
}
