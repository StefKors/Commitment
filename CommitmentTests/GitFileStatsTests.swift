//
//  GitFileStatsTests.swift
//  CommitmentTests
//
//  Created by Stef Kors on 03/05/2023.
//

import XCTest
@testable import Commitment

final class GitFileStatsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParseFromString() throws {
        let input = "4    1    Commitment/Views/AppViews/ActiveChangesMainView.swift"
        let output = GitFileStats(input)
        XCTAssertEqual(output.fileChanged, "Commitment/Views/AppViews/ActiveChangesMainView.swift")
        XCTAssertEqual(output.insertions, 4)
        XCTAssertEqual(output.deletions, 1)
    }

    func testParseFromStringOnlyDeletions() throws {
        let input = "0    1    Commitment/CommitmentApp.swift"
        let output = GitFileStats(input)
        XCTAssertEqual(output.fileChanged, "Commitment/CommitmentApp.swift")
        XCTAssertEqual(output.insertions, 0)
        XCTAssertEqual(output.deletions, 1)
    }

    func testParseFromStringOnlyInsertions() throws {
        let input = "1    0    Commitment/CommitmentApp.swift"
        let output = GitFileStats(input)
        XCTAssertEqual(output.fileChanged, "Commitment/CommitmentApp.swift")
        XCTAssertEqual(output.insertions, 1)
        XCTAssertEqual(output.deletions, 0)
    }

    let testData: [String] = ["32    46    Commitment/CommitmentApp.swift", "41    52    Commitment/CommitmentApp.swift", "7    40    Commitment/CommitmentApp.swift", "4    72    Commitment/CommitmentApp.swift", "48    75    Commitment/CommitmentApp.swift", "68    51    Commitment/CommitmentApp.swift", "17    3    Commitment/CommitmentApp.swift", "14    26    Commitment/CommitmentApp.swift", "2    31    Commitment/CommitmentApp.swift", "49    9    Commitment/CommitmentApp.swift", "6    64    Commitment/CommitmentApp.swift", "70    16    Commitment/CommitmentApp.swift", "60    51    Commitment/CommitmentApp.swift", "4    47    Commitment/CommitmentApp.swift", "33    64    Commitment/CommitmentApp.swift", "71    70    Commitment/CommitmentApp.swift", "44    4    Commitment/CommitmentApp.swift", "42    69    Commitment/CommitmentApp.swift", "65    66    Commitment/CommitmentApp.swift", "21    14    Commitment/CommitmentApp.swift", "2    40    Commitment/CommitmentApp.swift", "9    8    Commitment/CommitmentApp.swift", "38    73    Commitment/CommitmentApp.swift", "46    30    Commitment/CommitmentApp.swift", "74    55    Commitment/CommitmentApp.swift", "29    12    Commitment/CommitmentApp.swift", "66    14    Commitment/CommitmentApp.swift", "31    18    Commitment/CommitmentApp.swift", "33    27    Commitment/CommitmentApp.swift", "70    48    Commitment/CommitmentApp.swift", "71    26    Commitment/CommitmentApp.swift", "11    68    Commitment/CommitmentApp.swift", "24    70    Commitment/CommitmentApp.swift", "50    36    Commitment/CommitmentApp.swift", "21    4    Commitment/CommitmentApp.swift", "58    37    Commitment/CommitmentApp.swift", "13    32    Commitment/CommitmentApp.swift", "17    13    Commitment/CommitmentApp.swift", "8    31    Commitment/CommitmentApp.swift", "42    13    Commitment/CommitmentApp.swift", "18    57    Commitment/CommitmentApp.swift", "10    6    Commitment/CommitmentApp.swift", "73    56    Commitment/CommitmentApp.swift", "72    58    Commitment/CommitmentApp.swift", "30    10    Commitment/CommitmentApp.swift", "69    41    Commitment/CommitmentApp.swift", "18    42    Commitment/CommitmentApp.swift", "55    59    Commitment/CommitmentApp.swift", "0    61    Commitment/CommitmentApp.swift", "73    65    Commitment/CommitmentApp.swift", "50    71    Commitment/CommitmentApp.swift", "4    7    Commitment/CommitmentApp.swift", "17    68    Commitment/CommitmentApp.swift", "32    63    Commitment/CommitmentApp.swift", "49    54    Commitment/CommitmentApp.swift", "49    35    Commitment/CommitmentApp.swift", "49    27    Commitment/CommitmentApp.swift", "22    25    Commitment/CommitmentApp.swift", "50    15    Commitment/CommitmentApp.swift", "44    65    Commitment/CommitmentApp.swift", "24    50    Commitment/CommitmentApp.swift", "17    5    Commitment/CommitmentApp.swift", "62    26    Commitment/CommitmentApp.swift", "43    67    Commitment/CommitmentApp.swift", "25    4    Commitment/CommitmentApp.swift", "29    56    Commitment/CommitmentApp.swift", "64    53    Commitment/CommitmentApp.swift", "63    46    Commitment/CommitmentApp.swift", "11    73    Commitment/CommitmentApp.swift", "19    35    Commitment/CommitmentApp.swift", "59    21    Commitment/CommitmentApp.swift", "53    56    Commitment/CommitmentApp.swift", "42    28    Commitment/CommitmentApp.swift", "46    59    Commitment/CommitmentApp.swift", "27    8    Commitment/CommitmentApp.swift", "31    57    Commitment/CommitmentApp.swift", "23    0    Commitment/CommitmentApp.swift", "10    40    Commitment/CommitmentApp.swift", "28    62    Commitment/CommitmentApp.swift", "25    12    Commitment/CommitmentApp.swift", "57    20    Commitment/CommitmentApp.swift", "32    5    Commitment/CommitmentApp.swift", "45    25    Commitment/CommitmentApp.swift", "33    58    Commitment/CommitmentApp.swift", "43    8    Commitment/CommitmentApp.swift", "69    38    Commitment/CommitmentApp.swift", "25    18    Commitment/CommitmentApp.swift", "60    50    Commitment/CommitmentApp.swift", "18    17    Commitment/CommitmentApp.swift", "71    21    Commitment/CommitmentApp.swift", "53    47    Commitment/CommitmentApp.swift", "61    25    Commitment/CommitmentApp.swift", "7    61    Commitment/CommitmentApp.swift", "53    75    Commitment/CommitmentApp.swift", "19    30    Commitment/CommitmentApp.swift", "37    20    Commitment/CommitmentApp.swift", "24    35    Commitment/CommitmentApp.swift", "71    72    Commitment/CommitmentApp.swift", "5    24    Commitment/CommitmentApp.swift", "66    44    Commitment/CommitmentApp.swift"]

    func testPerformance() throws {
        self.measure {
            for sample in testData {
                let output = GitFileStats(sample)
                XCTAssertNotNil(output.fileChanged)
            }
        }
    }

}
