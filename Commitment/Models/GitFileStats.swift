//
//  GitFileStats.swift
//  Commitment
//
//  Created by Stef Kors on 01/05/2023.
//

import Foundation

struct GitFileStats: Codable {
    // 2 files changed, 5 insertions(+), 2 deletions(-)
    init(_ input: String) {
        print(input)
        let parts = input.components(separatedBy: ",")
        self.fileChanged = parts[safe: 0]?.firstCharInt() ?? 0
        self.insertions = parts[safe: 1]?.firstCharInt() ?? 0
        self.deletions = parts[safe: 2]?.firstCharInt() ?? 0
    }

    let fileChanged: Int
    let insertions: Int
    let deletions: Int
}

extension String {
    /// Returns the number at start of string. for example: "2 files changed" returns "2"
    /// - Returns: Number or nil
    func firstCharInt() -> Int? {
        if let changed = self.trimmingCharacters(in: .whitespaces).first,
           let value = Int(String(changed)) {
            return value
        }
        return nil
    }
}


extension String.SubSequence {
    /// Returns the number at start of string. for example: "2 files changed" returns "2"
    /// - Returns: Number or nil
    func firstCharInt() -> Int? {
        if let changed = self.trimmingCharacters(in: .whitespaces).first,
            let value = Int(String(changed)) {
            return value
        }
        return nil
    }
}
