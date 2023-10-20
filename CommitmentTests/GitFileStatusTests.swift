//
//  GitFileStatusTests.swift
//  CommitmentTests
//
//  Created by Stef Kors on 16/10/2023.
//

import XCTest
@testable import Commitment

final class GitFileStatusTests: XCTestCase {
    //    M Commitment.xcodeproj/project.pbxproj
    //    M  Commitment/Components/FileChangeIconView.swift
    //    M  Commitment/Components/FileDiffChangesView.swift
    //    A  Commitment/Components/FileIcons.swift
    let input: String = """
AM Commitment/Components/FileTypeIconView.swift
MM Commitment/Components/GitFileStatusView.swift
M  Commitment/Components/HighlightedText.swift
M  Commitment/Models/Shell/Shell+Git.swift
M  Commitment/Models/Shell/Shell+Run.swift
A  "Commitment/Screenshot 2023-10-16 at 11.35.53.png"
"""

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDoubleStateSingle() async throws {
        let line = "AM Commitment/Components/FileTypeIconView.swift"

        guard line.count > 3 else { fatalError("failed linecount") }
        var trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
        let fileState = String(trimmedLine.prefix(2))
        trimmedLine.removeFirst(2)
        var fileName = trimmedLine.trimmingCharacters(in: .whitespaces)
        // When file name contains spaces, need to ensure leading and trailing quoes escapes are removed
        fileName = fileName.trimmingCharacters(in: CharacterSet(charactersIn: "\"\\"))

        let status = GitFileStatus(path: fileName, state: fileState, stats: nil)

        XCTAssertEqual(status.state.index, .added)
        XCTAssertEqual(status.state.worktree, .modified)
    }

    func testDoubleState () async throws {
        let lines = input.lines
        // print("status lines \(lines)")
        let mapToStatus = await lines.asyncCompactMap({ line -> GitFileStatus? in
            //                print("map status")
            guard line.count > 3 else { return nil }
            var trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            let fileState = String(trimmedLine.prefix(2))
            trimmedLine.removeFirst(2)
            var fileName = trimmedLine.trimmingCharacters(in: .whitespaces)
            // When file name contains spaces, need to ensure leading and trailing quoes escapes are removed
            fileName = fileName.trimmingCharacters(in: CharacterSet(charactersIn: "\"\\"))

            // TODO: need to figure out a performant way to get stats....
            //                let stats = await self.numStat(file: fileName)
            return GitFileStatus(path: fileName, state: fileState, stats: nil)
        })


    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
