//
//  GitFileStatus.swift
//  Commitment
//
//  Created by Stef Kors on 12/01/2023.
//

import Foundation
import Git

extension GitFileStatus.State: Hashable {
    public static func == (lhs: Git.GitFileStatus.State, rhs: Git.GitFileStatus.State) -> Bool {
        return lhs.index == rhs.index &&
        lhs.worktree == rhs.worktree
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(index)
        hasher.combine(worktree)
    }
}

extension GitFileStatus: Hashable {
    public static func == (lhs: Git.GitFileStatus, rhs: Git.GitFileStatus) -> Bool {
        lhs.path == rhs.path &&
        lhs.state == rhs.state
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(path)
        hasher.combine(state)
    }
}
