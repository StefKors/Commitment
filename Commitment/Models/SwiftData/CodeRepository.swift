//
//  CodeRepository.swift
//  Commitment
//
//  Created by Stef Kors on 19/07/2023.
//

import SwiftUI
import SwiftData


@Model
@MainActor
final
class CodeRepository: Identifiable {
    @Attribute(.unique) var path: URL

    // Settings
    var editor: ExternalEditor = ExternalEditor.xcode
    var windowMode: SplitModeOptions = SplitModeOptions.changes

    // Shell
    var shell: Shell = Shell(workspace: "")

    // Stored repo info
    var branches: [GitReference] = []
    var commits: [Commit] = []
    // TODO: remove?
    var commitsAhead: [Commit] = []

    // Computed properties to easy reference
    var branch: GitReference? {
        branches.first(where: \.active)
    }

    init(path: URL) {
        self.path = path
        self.shell = Shell(workspace: path)
    }
}

