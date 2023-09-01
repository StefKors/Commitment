//
//  CodeRepository.swift
//  Commitment
//
//  Created by Stef Kors on 19/07/2023.
//

import SwiftUI
import SwiftData

struct NewShell {
    var workspace: URL

    init(workspace: URL) {
        self.workspace = workspace
    }
}

@Model
// @MainActor
final
class CodeRepository: Identifiable {
    @Attribute(.unique) var path: URL

    // Settings
    var editor: ExternalEditor
    var windowMode: SplitModeOptions

    // Shell
    // var cli: NewShell

    // Stored repo info
    var branches: [GitReference]
    var commits: [Commit]
    // TODO: remove?
    var commitsAhead: [Commit]

    // Computed properties to easy reference
    var branch: GitReference? {
        branches.first(where: \.active)
    }

    init(path: URL) {
        self.path = path
        // self.cli = NewShell(workspace: path)
        self.editor = ExternalEditor.xcode
        self.windowMode = SplitModeOptions.changes

        self.branches = []
        self.commits = []
        self.commitsAhead = []
    }
}

