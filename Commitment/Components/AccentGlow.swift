//
//  AccentGlow.swift
//  Difference
//
//  Created by Stef Kors on 03/10/2022.
//

import SwiftUI

struct AccentGlow: ViewModifier {
    @State private var shift: CGFloat = 14
    @State private var offset: CGFloat = -4

    func body(content: Content) -> some View {
        content
            .shadow(color: Color.accentColor.opacity(0.9), radius: shift, x: 0, y: shift)
            .onAppear() {
                withAnimation(Animation.easeInOut(duration: 4.2).repeatForever()) {
                    shift = 20
                }

                withAnimation(Animation.interpolatingSpring(stiffness: 5, damping: 3).repeatForever()) {
                    offset = 4
                }
            }
    }
}

extension View {
    func accentGlow() -> some View {
        modifier(AccentGlow())
    }
}

struct AccentGlow_Previews: PreviewProvider {
    static var previews: some View {
        AppIcon()
            .accentGlow()
    }
}
