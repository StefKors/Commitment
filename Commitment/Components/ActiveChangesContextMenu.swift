//
//  ActiveChangesContextMenu.swift
//  Commitment
//
//  Created by Stef Kors on 12/04/2023.
//

import SwiftUI

struct ActiveChangesContextMenuView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .contextMenu {
                Button {
                    print("TODO: discard changes")
                } label: {
                    Text("Discard Changes")
                }
                .keyboardShortcut(.delete)
            }
    }
}

extension View {
    func activeChangesContextMenu() -> some View {
        modifier(ActiveChangesContextMenuView())
    }
}

struct ActiveChangesContextMenu_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Text("Commands.swift")
                .activeChangesContextMenu()
        }
    }
}
