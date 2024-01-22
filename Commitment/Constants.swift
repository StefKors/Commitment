//
//  Constants.swift
//  Commitment
//
//  Created by Stef Kors on 05/05/2023.
//

import Foundation
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let globalCommitPanel = Self("globalCommitPanel", default: Shortcut(.r, modifiers: [.command, .shift]))
}

enum DiffViewMode: String, CaseIterable, Codable {
    case unified = "Unified"
    case sideBySide = "Side by Side"
}

// TODO: Convert to environment value that inherently passes type so it works like:
// @Environment(\.Settings.Diff.Mode) private var mode
class Settings {
    struct Window {
        static let LastSelectedRepo: String = "LastSelectedRepo"
    }
    struct Changes {
        static let ShowFullPathInActiveChanges: String = "ShowFullPathInActiveChanges"
        static let ShowFileIconInActiveChanges: String = "ShowFileIconInActiveChanges"
    }
    struct Diff {
        static let Mode: String = "DiffViewMode"
        static let ShowStatsBlocks: String = "ShowStatsBlocks"
    }
    struct Git {
        static let Provider: String = "ExternalGitProvider"
    }
    struct Editor {
        static let ExternalEditor: String = "ExternalEditor"
    }
}
