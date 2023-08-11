//
//  CommitHistorySplitView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI

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
