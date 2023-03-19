//
//  SidebarCommitLabelView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI


struct SidebarCommitLabelView: View {
    var commit: Commit
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(commit.subject)
                    .bold()
                HStack() {
                    AvatarView(email: commit.authorEmail)
                    Text(commit.authorName) + Text(" · ") +
                    Text(commit.commiterDate.formatted())
                }.foregroundColor(.secondary)
            }
            if commit.isLocal ?? false {
                Spacer()
                GroupBox {
                    Image(systemName: "arrow.up")
                        .foregroundColor(.secondary)
                }
            }
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
