//
//  Rotation.swift
//  Commitment
//
//  Created by Stef Kors on 27/02/2023.
//

import SwiftUI

struct Rotation: ViewModifier {
    let isEnabled: Bool

    @State private var isRotating = 0.0
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(isRotating))
            .onAppear {
                withAnimation(.linear(duration: 1)
                    .speed(1).repeatForever(autoreverses: false)) {
                        isRotating = 360.0
                    }
            }
    }
}

extension View {
    func rotation(isEnabled: Bool) -> some View {
        modifier(Rotation(isEnabled: isEnabled))
    }
}

struct Rotation_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Rectangle()
                .fill(.white)
                // .frame(width: 20, height: 20)
                .rotation(isEnabled: true)
        }
        .padding(50)
    }
}
