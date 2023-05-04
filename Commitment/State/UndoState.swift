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
    case commit
}

struct UndoAction: Identifiable, Equatable {
    let type: UndoActionType
    let arguments: [String]
    let id: UUID = .init()
    let createdAt: Date = .now
    var subtitle: String? = nil
}

extension UndoAction {
    static var sample = UndoAction(type: .stash, arguments: ["stash", "push", "--include-untracked", "-m", "Discard Change to UndoState.swift", "Commitment/State/UndoState.swift"])
    static var sampleStash = Self.sample
    static var sampleDiscardChanges = UndoAction(type: .discardChanges, arguments: ["stash", "push", "--include-untracked", "-m", "Discard Change to UndoState.swift", "Commitment/State/UndoState.swift"])
    static var sampleCommit = UndoAction(type: .commit, arguments: ["commit", "-m", "Add profile picture view to commit sidebar panel"], subtitle: "Add profile picture view to commit sidebar panel")
}

class UndoState: ObservableObject {
    @Published var stack: [UndoAction] = []
}

extension Collection where Element == UndoAction {
    func filters(allOf type: UndoActionType) -> [UndoAction] {
        return self.filter({ item in
            return item.type != type
        })
    }
}
