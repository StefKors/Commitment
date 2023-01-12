//
//  GitDiffPreviewContent.swift
//  Commitment
//
//  Created by Stef Kors on 12/01/2023.
//

import Foundation

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

        static func toDiff(_ unifiedDiff: String) -> GitDiff {
            return try! GitDiff(unifiedDiff: unifiedDiff)!
        }
    }
}
