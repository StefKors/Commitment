//
//  SidebarCommitLabelView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI
import Git

struct SidebarCommitLabelView: View {
    var commit: RepositoryLogRecord
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(commit.subject)
                .bold()
            HStack() {
                AvatarView(email: commit.authorEmail)
                Text(commit.authorName)
                Spacer()
                Text(commit.commiterDate.formatted())
            }
            .foregroundColor(.secondary)
        }
    }
}

extension Date {
    func formatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        return dateFormatter.string(from: self)
    }
}
