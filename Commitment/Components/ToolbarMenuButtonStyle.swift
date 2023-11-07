//
//  ToolbarMenuButtonStyle.swift
//  Commitment
//
//  Created by Stef Kors on 22/02/2023.
//

import SwiftUI

struct ToolbarMenuButtonStyle: ButtonStyle {
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

    var textColorPrimary: Color {
        if isHovering {
            return Color.white
        } else {
            return Color.primary
        }
    }

    var textColorSecondary: Color {
        if isHovering {
            return Color.white.darker()
        } else {
            return Color.secondary
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .foregroundStyle(textColorPrimary, textColorSecondary)
        }
        .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
        .background {
            RoundedRectangle(cornerRadius: 4)
                .fill(fillColor)
        }
//        .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
        .onHover(perform: { hoverState in
            isHovering = hoverState
        })
        .allowsHitTesting(isEnabled)
    }
}

extension ButtonStyle where Self == ToolbarMenuButtonStyle {
    /// Custom button style for the CustomMenu component
    static var toolbarMenuButtonStyle: ToolbarMenuButtonStyle { .init() }
}

struct ToolbarMenuButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button("Click Here! (Default)", action: {})
                .buttonStyle(.toolbarMenuButtonStyle)
                .padding()
                .previewDisplayName("Default")

            Button("Click Here! (Hover)", action: {})
                .buttonStyle(ToolbarMenuButtonStyle(isHovering: true))
                .padding()
                .previewDisplayName("Hover")

            Button("Click Here! (Disabled)", action: {})
                .buttonStyle(.toolbarMenuButtonStyle)
                .padding()
                .disabled(true)
                .previewDisplayName("Disabled")
        }
    }
}
