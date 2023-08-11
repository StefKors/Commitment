//
//  ActiveChangesState.swift
//  Commitment
//
//  Created by Stef Kors on 19/07/2023.
//

import Foundation

class ActiveChangesState {
    var diffs: [GitDiff] = []
    var status: [GitFileStatus] = []
}
