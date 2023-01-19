//
//  CommitHistorySplitView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI
import Git
import Defaults

extension Defaults.Keys {
    static let windowMode = Key<SplitModeOptions>("WindowMode", default: .changes)
}

enum SplitModeOptions: String, CaseIterable, Defaults.Serializable {
    case changes = "Changes"
    case history = "History"
}

struct MainRepoContentView: View {
    @EnvironmentObject var state: WindowState
    @Default(.windowMode) var modeSelection
    @State private var commitId: GitLogRecord.ID? = nil
    @State private var fileId: GitFileStatus.ID? = nil
    var body: some View {
        NavigationView {
            switch modeSelection {
            case .history:
                CommitHistoryView()

            case .changes:
                ActiveChangesView()
            }
        }
    }
}
