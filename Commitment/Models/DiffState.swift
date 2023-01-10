//
//  DiffState.swift
//  Commitment
//
//  Created by Stef Kors on 10/01/2023.
//

import Foundation

class DiffState: ObservableObject {
    @Published var diffs: [GitDiff] = []
}
