//
//  GitDiff.swift
//  GitDiff
//
//  Created by Guillermo Muntaner Perelló on 03/10/2018.
//

import Foundation

/// Represents a universal git diff
public class GitDiff: Equatable {
    public static func == (lhs: GitDiff, rhs: GitDiff) -> Bool {
        return lhs.addedFile == rhs.addedFile &&
        lhs.removedFile == rhs.removedFile &&
        lhs.hunks == rhs.hunks
    }

    
    public let addedFile: String
    
    public let removedFile: String
    
    public let hunks: [GitDiffHunk]
    
    public convenience init?(unifiedDiff: String) throws {
        let parsingResults = try GitDiffParser(unifiedDiff: unifiedDiff).parse()
        self.init(
            addedFile: parsingResults.addedFile,
            removedFile: parsingResults.removedFile,
            hunks: parsingResults.hunks)
    }
    
    internal init(
        addedFile: String,
        removedFile: String,
        hunks: [GitDiffHunk]
        ) {
        self.addedFile = addedFile
        self.removedFile = removedFile
        self.hunks = hunks
    }
    
    internal var description: String {
        let header = """
        --- \(removedFile)
        +++ \(addedFile)
        """
        return hunks.reduce(into: header) {
            $0 +=  "\n\($1.description)"
        }
    }
}
