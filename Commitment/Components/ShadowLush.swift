//
//  ShadowLush.swift
//  Commitment
//
//  Created by Stef Kors on 24/10/2023.
//  based on: https://www.joshwcomeau.com/shadow-palette/

import SwiftUI

struct ShadowLush: ViewModifier {

    @Environment(\.colorScheme) private var colorScheme

    private var shadowColor: Color {
        switch colorScheme {
        case .light:
            Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 0.25)
        case .dark:
            Color(red: 0.05, green: 0.05, blue: 0.05, opacity: 0.25)
        @unknown default:
            // dark?
            Color(red: 0.05, green: 0.05, blue: 0.05, opacity: 0.25)
        }
    }

    func body(content: Content) -> some View {
        content
            .shadow(color: shadowColor, radius: 0.6, y: 0.5)
            .shadow(color: shadowColor, radius: 1.8, y: 1.6)
            .shadow(color: shadowColor, radius: 4.5, y: 4)
            .shadow(color: shadowColor, radius: 11, y: 9.8)
    }
}

extension View {
    func shadowLush() -> some View {
        modifier((ShadowLush()))
    }
}

#Preview("Dark") {
    RoundedRectangle(cornerRadius: 12)
        .fill(.background)
        .frame(width: 200, height: 100, alignment: .center)
        .shadowLush()
        .padding(50)
        .background {
            Rectangle().fill(.windowBackground)
        }
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    RoundedRectangle(cornerRadius: 12)
        .fill(.background)
        .frame(width: 200, height: 100, alignment: .center)
        .shadowLush()
        .padding(50)
        .background {
            Rectangle().fill(.windowBackground)
        }
        .preferredColorScheme(.light)
}


