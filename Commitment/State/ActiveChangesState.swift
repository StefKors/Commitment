//
//  ActiveChangesState.swift
//  Commitment
//
//  Created by Stef Kors on 19/07/2023.
//

import SwiftUI

// TODO: fetch and display stats for active changes
// TODO: generate quick commit title
class ActiveChangesState: ObservableObject {
    @Published var diffs: [GitDiff] = []
    @Published var status: [GitFileStatus] = []
    
    @Published var GitCommitStats: GitCommitStats? = nil
}
