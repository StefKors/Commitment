//
//  UndoState.swift
//  Commitment
//
//  Created by Stef Kors on 12/04/2023.
//

import SwiftUI

enum UndoActionType: String {
    case stash
    case discardChanges = "Discard Changes"
}

struct UndoAction: Identifiable, Equatable {
    let type: UndoActionType
    let arguments: [String]
    let id: UUID = .init()
    let createdAt: Date = .now
}

extension UndoAction {
    static var sample = UndoAction(type: .stash, arguments: ["stash", "push", "--include-untracked", "-m", "Discard Change to UndoState.swift", "Commitment/State/UndoState.swift"])
    static var sampleStash = Self.sample
    static var sampleDiscardChanges = UndoAction(type: .discardChanges, arguments: ["stash", "push", "--include-untracked", "-m", "Discard Change to UndoState.swift", "Commitment/State/UndoState.swift"])
}

class UndoState: ObservableObject {
    @Published var stack: [UndoAction] = []
}