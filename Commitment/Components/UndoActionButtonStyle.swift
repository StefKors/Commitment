//
//  UndoActionButtonStyle.swift
//  Commitment
//
//  Created by Stef Kors on 22/02/2023.
//

import SwiftUI

struct UndoActionButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    @State var isHovering: Bool = false

    var opacity: Double {
        if !isEnabled {
            return 1
        } else if isHovering {
            return 1
        } else {
            return 0.6
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .font(.system(size: 11))
        }
        .padding(EdgeInsets(top: 6, leading: 4, bottom: 6, trailing: 4))
        .background {
            RoundedRectangle(cornerRadius: 6)
                .fill(.separator.opacity(opacity))
        }
        .onHover(perform: { hoverState in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovering = hoverState
            }
        })
        .allowsHitTesting(isEnabled)
    }
}

extension ButtonStyle where Self == UndoActionButtonStyle {
    /// Custom button style for the CustomMenu component
    static var undo: UndoActionButtonStyle { .init() }
}

struct UndoActionButtonStyle_Previews: PreviewProvider {
    static let action: UndoAction = .sampleDiscardChanges

    static var previews: some View {
        VStack {
            Text("(Default)")
            Button("undo", action: {})
                .buttonStyle(.undo)
                .padding()
                .previewDisplayName("Default")

            Text("(Disabled)")
            Button("undo", action: {})
                .buttonStyle(.undo)
                .padding()
                .disabled(true)
                .previewDisplayName("Disabled")

            UndoActionView(action: action)
                .frame(maxWidth: 250)
                .scenePadding()
        }.scenePadding()
    }
}
