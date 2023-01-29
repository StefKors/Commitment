//
//  CommitHistorySplitView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI

enum SplitModeOptions: String, CaseIterable, Codable {
    case changes = "Changes"
    case history = "History"
}

struct MainRepoContentView: View {
    @EnvironmentObject var appModel: AppModel
    @State private var commitId: GitLogRecord.ID? = nil
    @State private var fileId: GitFileStatus.ID? = nil
    
    var body: some View {
        NavigationView {
            switch appModel.windowMode {
            case .history:
                CommitHistoryView()
                
            case .changes:
                ActiveChangesView()
            }
        }
    }
}
