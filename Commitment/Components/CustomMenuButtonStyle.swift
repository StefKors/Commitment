//
//  CustomMenuButtonStyle.swift
//  Commitment
//
//  Created by Stef Kors on 22/02/2023.
//

import SwiftUI

struct CustomMenuButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    @State var isHovering: Bool = false

    var fillColor: Color {
        if !isEnabled {
            return Color.clear
        } else if isHovering {
            return Color(.selectedContentBackgroundColor)
        } else {
            return Color.clear
        }
    }

    var textColor: Color {
        if isHovering {
            return Color.white
        } else {
            return Color.primary
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .foregroundColor(textColor)
        }
        .padding(EdgeInsets(top: 6, leading: 4, bottom: 6, trailing: 4))
        .background {
            RoundedRectangle(cornerRadius: 6)
                .fill(fillColor)
        }
        .onHover(perform: { hoverState in
            isHovering = hoverState
        })
        .allowsHitTesting(isEnabled)
    }
}

extension ButtonStyle where Self == CustomMenuButtonStyle {
    /// Custom button style for the CustomMenu component
    static var customButtonStyle: CustomMenuButtonStyle { .init() }
}

struct CustomMenuButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Click Here!", action: {})
            .buttonStyle(.customButtonStyle)
            .padding()
            .previewDisplayName("Default")

        Button("Click Here!", action: {})
            .buttonStyle(.customButtonStyle)
            .padding()
            .disabled(true)
            .previewDisplayName("Disabled")
    }
}
