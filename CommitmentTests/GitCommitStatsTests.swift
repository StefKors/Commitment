//
//  GitCommitStatsTests.swift
//  CommitmentTests
//
//  Created by Stef Kors on 03/05/2023.
//

import XCTest
@testable import Commitment

final class GitCommitStatsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParseFromString() throws {
        let input = "2 files changed, 5 insertions(+), 2 deletions(-)"
        let output = GitCommitStats(input)
        XCTAssertEqual(output.filesChanged, 2)
        XCTAssertEqual(output.insertions, 5)
        XCTAssertEqual(output.deletions, 2)
    }

    func testParseFromStringOnlyDeletions() throws {
        let input = "2 files changed, 5 deletions(-)"
        let output = GitCommitStats(input)
        XCTAssertEqual(output.filesChanged, 2)
        XCTAssertEqual(output.insertions, 0)
        XCTAssertEqual(output.deletions, 5)
    }

    func testParseFromStringOnlyInsertions() throws {
        let input = "2 files changed, 5 insertions(+)"
        let output = GitCommitStats(input)
        XCTAssertEqual(output.filesChanged, 2)
        XCTAssertEqual(output.insertions, 5)
        XCTAssertEqual(output.deletions, 0)
    }

    let testData: [String] = ["63 files changed, 28 insertions(+), 64 deletions(-)", "64 files changed, 19 insertions(+), 20 deletions(-)", "69 files changed, 71 insertions(+), 74 deletions(-)", "3 files changed, 4 insertions(+), 17 deletions(-)", "70 files changed, 24 insertions(+), 12 deletions(-)", "59 files changed, 5 insertions(+), 30 deletions(-)", "17 files changed, 20 insertions(+), 58 deletions(-)", "59 files changed, 43 insertions(+), 60 deletions(-)", "40 files changed, 40 insertions(+), 61 deletions(-)", "30 files changed, 2 insertions(+), 12 deletions(-)", "33 files changed, 53 insertions(+), 63 deletions(-)", "43 files changed, 57 insertions(+), 37 deletions(-)", "14 files changed, 66 insertions(+), 56 deletions(-)", "10 files changed, 73 insertions(+), 26 deletions(-)", "35 files changed, 22 insertions(+), 2 deletions(-)", "72 files changed, 72 insertions(+), 10 deletions(-)", "35 files changed, 55 insertions(+), 37 deletions(-)", "13 files changed, 68 insertions(+), 20 deletions(-)", "12 files changed, 21 insertions(+), 37 deletions(-)", "38 files changed, 71 insertions(+), 45 deletions(-)", "69 files changed, 15 insertions(+), 61 deletions(-)", "64 files changed, 14 insertions(+), 60 deletions(-)", "63 files changed, 63 insertions(+), 67 deletions(-)", "16 files changed, 64 insertions(+), 25 deletions(-)", "74 files changed, 75 insertions(+), 36 deletions(-)", "69 files changed, 18 insertions(+), 44 deletions(-)", "56 files changed, 17 insertions(+), 4 deletions(-)", "72 files changed, 12 insertions(+), 64 deletions(-)", "30 files changed, 5 insertions(+), 64 deletions(-)", "34 files changed, 44 insertions(+), 33 deletions(-)", "63 files changed, 1 insertions(+), 11 deletions(-)", "8 files changed, 41 insertions(+), 6 deletions(-)", "18 files changed, 24 insertions(+), 26 deletions(-)", "6 files changed, 28 insertions(+), 58 deletions(-)", "61 files changed, 64 insertions(+), 45 deletions(-)", "50 files changed, 57 insertions(+), 28 deletions(-)", "10 files changed, 31 insertions(+), 61 deletions(-)", "34 files changed, 35 insertions(+), 74 deletions(-)", "14 files changed, 47 insertions(+), 75 deletions(-)", "45 files changed, 55 insertions(+), 8 deletions(-)", "43 files changed, 73 insertions(+), 38 deletions(-)", "58 files changed, 52 insertions(+), 21 deletions(-)", "71 files changed, 68 insertions(+), 15 deletions(-)", "72 files changed, 48 insertions(+), 35 deletions(-)", "24 files changed, 68 insertions(+), 40 deletions(-)", "39 files changed, 30 insertions(+), 28 deletions(-)", "69 files changed, 13 insertions(+), 29 deletions(-)", "75 files changed, 7 insertions(+), 41 deletions(-)", "37 files changed, 52 insertions(+), 17 deletions(-)", "41 files changed, 31 insertions(+), 14 deletions(-)", "1 files changed, 9 insertions(+), 53 deletions(-)", "67 files changed, 73 insertions(+), 38 deletions(-)", "75 files changed, 42 insertions(+), 26 deletions(-)", "13 files changed, 21 insertions(+), 42 deletions(-)", "25 files changed, 16 insertions(+), 5 deletions(-)", "67 files changed, 67 insertions(+), 14 deletions(-)", "39 files changed, 54 insertions(+), 41 deletions(-)", "14 files changed, 23 insertions(+), 17 deletions(-)", "51 files changed, 31 insertions(+), 22 deletions(-)", "39 files changed, 15 insertions(+), 34 deletions(-)", "37 files changed, 21 insertions(+), 72 deletions(-)", "1 files changed, 75 insertions(+), 10 deletions(-)", "26 files changed, 62 insertions(+), 2 deletions(-)", "5 files changed, 75 insertions(+), 8 deletions(-)", "45 files changed, 73 insertions(+), 49 deletions(-)", "49 files changed, 19 insertions(+), 59 deletions(-)", "45 files changed, 23 insertions(+), 62 deletions(-)", "10 files changed, 16 insertions(+), 43 deletions(-)", "23 files changed, 21 insertions(+), 5 deletions(-)", "56 files changed, 69 insertions(+), 32 deletions(-)", "17 files changed, 19 insertions(+), 70 deletions(-)", "39 files changed, 69 insertions(+), 13 deletions(-)", "35 files changed, 67 insertions(+), 66 deletions(-)", "13 files changed, 2 insertions(+), 19 deletions(-)", "72 files changed, 58 insertions(+), 35 deletions(-)", "68 files changed, 61 insertions(+), 30 deletions(-)", "11 files changed, 73 insertions(+), 49 deletions(-)", "32 files changed, 55 insertions(+), 70 deletions(-)", "69 files changed, 37 insertions(+), 11 deletions(-)", "75 files changed, 24 insertions(+), 70 deletions(-)", "2 files changed, 37 insertions(+), 23 deletions(-)", "59 files changed, 5 insertions(+), 36 deletions(-)", "42 files changed, 43 insertions(+), 27 deletions(-)", "16 files changed, 5 insertions(+), 43 deletions(-)", "69 files changed, 42 insertions(+), 22 deletions(-)", "6 files changed, 6 insertions(+), 33 deletions(-)", "43 files changed, 28 insertions(+), 19 deletions(-)", "58 files changed, 67 insertions(+), 54 deletions(-)", "46 files changed, 28 insertions(+), 41 deletions(-)", "61 files changed, 34 insertions(+), 23 deletions(-)", "35 files changed, 26 insertions(+), 11 deletions(-)", "67 files changed, 29 insertions(+), 16 deletions(-)", "30 files changed, 18 insertions(+), 66 deletions(-)", "64 files changed, 19 insertions(+), 19 deletions(-)", "63 files changed, 72 insertions(+), 6 deletions(-)", "50 files changed, 53 insertions(+), 56 deletions(-)", "9 files changed, 41 insertions(+), 46 deletions(-)", "28 files changed, 43 insertions(+), 72 deletions(-)", "15 files changed, 33 insertions(+), 29 deletions(-)", "18 files changed, 66 insertions(+), 68 deletions(-)"]

    func testPerformance() throws {
        self.measure {
            for sample in testData {
                let output = GitCommitStats(sample)
            }
        }
    }

}
