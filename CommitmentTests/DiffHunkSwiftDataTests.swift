//
//  DiffHunkSwiftDataTests.swift
//  CommitmentTests
//
//  Created by Stef Kors on 04/03/2024.
//

import XCTest
import SwiftData
@testable import Commitment
import Foundation
import SwiftData
// custom context indicator =


let sharedModelContainer: ModelContainer = {
    let schema = Schema([
        GitDiffHunk.self,
        GitDiffHunkLine.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

@MainActor
final class ToManyPerformanceSwiftDataTests: XCTestCase {

    func testAddTagFromItem() throws {
        let context = sharedModelContainer.mainContext
        measure {
            let hunk = GitDiffHunk(oldLineStart: 0, oldLineSpan: 0, newLineStart: 0, newLineSpan: 0, header: "")
            context.insert(hunk)
            for i in 0..<10 {
                let line = GitDiffHunkLine(type: .addition, text: "\(i)")
                hunk.lines.append(line)
            }
            try? context.save()
            print(hunk.lines.count ?? "null")
        }
    }
}
