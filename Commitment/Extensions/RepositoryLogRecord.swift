//
//  RepositoryLogRecord.swift
//  Commitment
//
//  Created by Stef Kors on 12/01/2023.
//

import Foundation
import Git

extension GitLogRecord: Hashable {
    public static func == (lhs: Git.GitLogRecord, rhs: Git.GitLogRecord) -> Bool {
        lhs.hash == rhs.hash
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(hash)
        hasher.combine(shortHash)
        hasher.combine(authorName)
        hasher.combine(authorEmail)
        hasher.combine(subject)
        hasher.combine(body)
        hasher.combine(commiterDate)
        hasher.combine(refNames)
    }
}
