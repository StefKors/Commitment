//
//  PendingCommitSummaryView.swift
//  Commitment
//
//  Created by Stef Kors on 17/04/2023.
//

import SwiftUI

struct PendingCommitSummaryView: View {
    @EnvironmentObject private var repo: CodeRepository

    var body: some View {
        ZStack {
            let items = repo.commitsAhead.sorted(by: { A, B in
                return A.commiterDate < B.commiterDate
            }).suffix(3)
            ForEach(Array(zip(items.indices, items)), id: \.0) { index, commit in
                PendingCommitSummaryItemView(commit: commit)
                    .stacked(at: index, in: repo.commitsAhead.count)
                    .id(commit.hash)
                    .transition(.opacity.animation(.stiffBounce).combined(with: .scale.animation(.interpolatingSpring(stiffness: 1000, damping: 80))))
                    .animation(.stiffBounce, value: items)
            }
        }
    }
}

struct PendingCommitSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        PendingCommitSummaryView()
    }
}
