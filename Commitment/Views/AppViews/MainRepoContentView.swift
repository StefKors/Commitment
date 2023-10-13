//
//  CommitHistorySplitView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI

struct MainRepoContentView: View {
    @EnvironmentObject private var repo: CodeRepository

    var body: some View {
        NavigationView {
            switch repo.windowMode {
            case .history:
                CommitHistoryView()

            case .changes:
                ActiveChangesView()
            }
        }
    }
}
