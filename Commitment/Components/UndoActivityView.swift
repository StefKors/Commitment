//
//  UndoActivityView.swift
//  Commitment
//
//  Created by Stef Kors on 12/04/2023.
//

import SwiftUI

struct UndoActivityView: View {
    @EnvironmentObject private var undo: UndoState

    var body: some View {
        ZStack {
            let items = undo.stack.suffix(3)
            ForEach(Array(zip(items.indices, items)), id: \.0) { index, action in
                UndoActionView(action: action)
                    .stacked(at: index, in: undo.stack.count)
                    .id(action.id)
                    .transition(.opacity.animation(.stiffBounce).combined(with: .scale.animation(.interpolatingSpring(stiffness: 1000, damping: 80))))
                    .animation(.stiffBounce, value: items)
            }
        }
        .padding(.horizontal)
    }
}

struct UndoActivityView_Previews: PreviewProvider {
    static var previews: some View {
        UndoActivityView()
    }
}

