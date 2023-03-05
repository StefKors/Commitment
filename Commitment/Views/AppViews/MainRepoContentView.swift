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
