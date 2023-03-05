//
//  KeyboardKey.swift
//  Commitment
//
//  Created by Stef Kors on 16/01/2023.
//

import SwiftUI

struct KeyboardKey: View {
    let key: String

    @State private var isHovering: Bool = false
    var body: some View {
        RoundedRectangle(cornerRadius: 4, style: .continuous)
            .fill(Color("KeySides"))
            .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
            .shadow(radius: isHovering ? 2 : 4, y: 2)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .stroke(Color("KeyBorder"), lineWidth: 1)
            })
            .overlay(content: {
                ZStack {
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Color("KeyTop"))
                        .padding(1)
                        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                    Text(key)
                        .fontDesign(.monospaced)
                        .font(.system(size: 14))
                }
                .offset(y: isHovering ? -1 : -2)
            })
            .frame(width: 18, height: 16, alignment: .centerFirstTextBaseline)
            .foregroundColor(Color("KeyLabel").opacity(0.7))
            .onHover { hoverState in
                withAnimation(.interpolatingSpring(stiffness: 900, damping: 30)) {
                    isHovering = hoverState
                }
            }
            .rotation3DEffect(.degrees(4), axis: (x: 1, y: 0.0, z: 0.0))
            .fontDesign(.monospaced)
            .help("Press \(key)")
            .lineSpacing(1)
            // .padding()
            // .scaleEffect(4)
    }
}

struct KeyboardKey_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            KeyboardKey(key: "⌘")
                .scenePadding()
            KeyboardKey(key: "⇧")
                .scenePadding()
            KeyboardKey(key: "F")
                .scenePadding()
        }.scenePadding()
    }
}
