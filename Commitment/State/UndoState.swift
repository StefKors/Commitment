//
//  UndoState.swift
//  Commitment
//
//  Created by Stef Kors on 12/04/2023.
//

import SwiftUI

enum UndoActionType {
    case stash(arguments: [String])
}

struct UndoAction: Identifiable {
    let type: UndoActionType
    let id: UUID = .init()
    let createdAt: Date = .now
}

class UndoState: ObservableObject {
    @Published var stack: [UndoAction] = []
}
