//
//  CommitState.swift
//  Commitment
//
//  Created by Stef Kors on 13/01/2023.
//

import Foundation
import Git

class CommitState: ObservableObject {
    @Published var commits: [GitLogRecord]? = nil
}
