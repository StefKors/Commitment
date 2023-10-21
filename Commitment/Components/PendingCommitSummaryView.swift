//
//  PendingCommitSummaryView.swift
//  Commitment
//
//  Created by Stef Kors on 17/04/2023.
//

import SwiftUI

struct PendingCommitSummaryView: View {
    @Environment(CodeRepository.self) private var repository

    var body: some View {
        ZStack {
            let items = self.repository.commitsAhead.sorted(by: { A, B in
                return A.commiterDate < B.commiterDate
            }).suffix(3)
            ForEach(Array(zip(items.indices, items)), id: \.0) { index, commit in
                PendingCommitSummaryItemView(commit: commit)
                    .stacked(at: index, in: self.repository.commitsAhead.count)
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
