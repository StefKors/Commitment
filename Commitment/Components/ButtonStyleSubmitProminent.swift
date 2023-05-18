//
//  ButtonStyleSubmitProminent.swift
//  Commitment
//
//  Created by Stef Kors on 18/05/2023.
//

import SwiftUI

struct ButtonStyleSubmitProminent: ViewModifier {
    @Environment(\.isEnabled) private var isEnabled

    var transition: AnyTransition {
        .opacity.animation(.easeInOut(duration: 0.2))
    }

    func body(content: Content) -> some View {
        Group {
            if isEnabled {
                content
                    .buttonStyle(.prominentButtonStyle)
                    .transition(transition)
            } else {
                content
                    .buttonStyle(.regularButtonStyle)
                    .transition(transition)
            }
        }
        .animation(.spring(), value: isEnabled)
    }
}

extension View {
    func buttonStyleSubmitProminent() -> some View {
        modifier(ButtonStyleSubmitProminent())
    }
}

struct ButtonStyleSubmitProminent_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button("Click Here! (Default)", action: {})
                .buttonStyleSubmitProminent()
                .padding()
                .previewDisplayName("Default")

            Button("Click Here! (Disabled)", action: {})
                .buttonStyleSubmitProminent()
                .padding()
                .disabled(true)
                .previewDisplayName("Disabled")

            Button("Click Here! (Dark)", action: {})
                .buttonStyleSubmitProminent()
                .padding()
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Default")
        }
    }
}
