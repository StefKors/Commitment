//
//  CommitHistoryDetailView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI
import Git

struct CommitHistoryDetailView: View {
    var fileId: GitFileStatus.ID? = nil

    var body: some View {
        Text("CommitHistoryDetailView \(fileId.debugDescription)")
    }
}
