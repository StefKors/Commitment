//
//  DiffParserTests.swift
//  CommitmentTests
//
//  Created by Stef Kors on 03/05/2023.
//

import XCTest
@testable import Commitment

final class DiffParserTests: XCTestCase {
    
    // We want to check if the first line character is correctly removed.
    // That's where the `+` or `-` or ` ` (unchanged) is and we will parse that to a specific type.
    func testSimpleVersionBump() throws {
        let output = try? GitDiff(unifiedDiff:  simpleVersionBump)

        let firstHunk = output?.hunks.first
        let firstLine = firstHunk?.lines.first

        XCTAssertEqual(output?.hunks.count, 1)
        XCTAssertEqual(firstLine?.type, .unchanged)
        guard let text = firstLine?.text else {
            XCTFail("expected text on first line of diff")
            return
        }

        XCTAssertEqual(text, "{")
    }

    func testDataWithBrokenInitalLine() throws {
        let output = try? GitDiff(unifiedDiff:  dataWithBrokenInitalLine)

        let firstHunk = output?.hunks.first
        let firstLine = firstHunk?.lines.first

        XCTAssertEqual(output?.hunks.count, 1)
        XCTAssertEqual(firstLine?.type, .unchanged)
        guard let text = firstLine?.text else {
            XCTFail("expected text on first line of diff")
            return
        }
        XCTAssertEqual(text, "")
    }

    let dataWithBrokenInitalLine: String = """
diff --git a/ColorPicker/ColorPickerApp.swift b/ColorPicker/ColorPickerApp.swift
index 0b3fc7c..094ba28 100644
--- a/ColorPicker/ColorPickerApp.swift
+++ b/ColorPicker/ColorPickerApp.swift
@@ -19,6 +19,11 @@ import AppKit

     @AppStorage("ColorHistory") var colorHistory: [HistoricalColor] = []
     @AppStorage("showAlpha") var showAlpha: Bool = false
+    @AppStorage("ColorStyle") var colorStyle: ColorStyle = .SwiftUI {
+        didSet {
+            self.refreshRightClickMenu()
+        }
+    }
     @Published var isOn: Bool = true
     @Published var showCode: Bool = false
     @Published var setEffect: Bool = false
"""

    let simpleVersionBump: String = """
diff --git a/package.json b/package.json
index 09ff520..4f245a9 100644
--- a/package.json
+++ b/package.json
@@ -1,6 +1,6 @@
 {
   "name": "playground",
-  "version": "2.0.0",
+  "version": "2.0.1",
   "main": "index.js",
   "license": "MIT",
   "dependencies": {
"""

}
