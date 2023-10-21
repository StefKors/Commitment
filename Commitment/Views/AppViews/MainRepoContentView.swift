//
//  CommitHistorySplitView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI

struct MainRepoContentView: View {
    @Environment(CodeRepository.self) private var repository

    var body: some View {
        NavigationView {
            switch self.repository.windowMode {
            case .history:
                CommitHistoryView()

            case .changes:
                ActiveChangesView()
            }
        }
    }
}
