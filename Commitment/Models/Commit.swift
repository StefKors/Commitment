//
//  Commit.swift
//  Commitment
//
//  Created by Stef Kors on 12/01/2023.
//

import Foundation

struct Commit: Equatable {
    let hash: String
    let message: String
    let author: String
    let date: Date
}
