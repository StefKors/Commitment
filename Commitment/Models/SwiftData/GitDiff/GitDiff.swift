//
//  GitDiff.swift
//  GitDiff
//
//  Created by Guillermo Muntaner Perelló on 03/10/2018.
//

import Foundation

/// Represents a universal git diff
public struct GitDiff: Codable, Equatable {
    public static func == (lhs: GitDiff, rhs: GitDiff) -> Bool {
        return lhs.addedFile == rhs.addedFile &&
        lhs.removedFile == rhs.removedFile &&
        lhs.hunks == rhs.hunks &&
        lhs.lines == rhs.lines
    }
    
    public let addedFile: String
    
    public let removedFile: String
    
    public let hunks: [GitDiffHunk]

    public var lines: [GitDiffHunkLine]

    // Source string of diff
    public let unifiedDiff: String
    
    public init?(unifiedDiff: String) throws {
        let parsingResults = try GitDiffParser(unifiedDiff: unifiedDiff).parse()
        self.init(
            addedFile: parsingResults.addedFile,
            removedFile: parsingResults.removedFile,
            hunks: parsingResults.hunks,
            unifiedDiff: unifiedDiff
        )
    }
    
    internal init(
        addedFile: String,
        removedFile: String,
        hunks: [GitDiffHunk],
        unifiedDiff: String
    ) {
        self.addedFile = addedFile
        self.removedFile = removedFile
        self.hunks = hunks
        self.unifiedDiff = unifiedDiff
        self.lines = hunks.map { hunk in
            hunk.lines
        }.flatMap { $0 }
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

extension GitDiff {
    struct Preview {
        /// A unified Diff String of a major version bump in a package.json file
        static let versionBump: String = """
diff --git a/package.json b/package.json
index 81aa5a5..4b49bb3 100644
--- a/package.json
+++ b/package.json
@@ -1,6 +1,6 @@
 {
~
   "name": "playground",
~
   "version":
-"1.0.5",
+"2.0.0",
~
   "main": "index.js",
~
   "license": "MIT",
~
   "dependencies": {
~
"""
        /// A unified Diff String of a deleted file
        static let deletedFile: String = """
diff --git a/objs.js b/objs.js
deleted file mode 100644
index c8ecb36..0000000
--- a/objs.js
+++ /dev/null
@@ -1 +0,0 @@
-const sequence = {"time":"2020-08-26T13:17:20.079Z","card":{"active":true,"data":{"mirrors":["https://api.nuc.bob.local/v5/organization(21)"],"translateDate":"2020-08-26T13:17:20.079Z","username":"stef_kors_doggo","billingCode":"prototype-v2","canSelfServe":true,"monthlyPrice":10900,"annualPrice":118800,"generation":4,"plan":"Prototype"},"type":"account@1.0.0","slug":"account-twentyto","name":"twentyto"},"actor":"9e7c113e-0c67-412c-b3bf-c74d24c0b544"}
~
"""
        /// A unified Diff String of an added file
        static let addedFile: String = """
"""

        static func toDiff(_ unifiedDiff: String) -> GitDiff? {
            return try? GitDiff(unifiedDiff: unifiedDiff)!
        }
    }
}

extension Collection where Element == GitDiff {
    func fileStatus(for fileId: GitFileStatus.ID?) -> GitDiff? {
        guard let fileId else { return nil }
        // Gets file path while supporting renamed/moved files
        // handles renamed
        guard let filePath = fileId.split(separator: " -> ").last else { return nil }
        let path = String(filePath)
        return self.first { diff in
            return diff.addedFile.contains(path)
        }
    }
}
