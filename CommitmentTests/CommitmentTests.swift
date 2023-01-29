//
//  CommitmentTests.swift
//  CommitmentTests
//
//  Created by Stef Kors on 06/04/2022.
//

import XCTest
@testable import Commitment

class CommitmentTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    class TestObject: Identifiable {
        internal init(id: UUID = .init()) {
            self.id = id
        }

        var id: UUID
    }

    func createData(with idToFind: UUID) -> [TestObject] {
        var data: [TestObject] = []
        for index in 1...500000 {
            if index == 250000 {
                data.append(TestObject(id: idToFind))
            } else {
                data.append(TestObject())
            }
        }
        return data
    }

    func testCollectionSearchLoop() throws {
        // This is an example of a performance test case.
        let idToFind = UUID()
        let testdata = createData(with: idToFind)
        self.measure {
            let foundObject = testdata.first(with: idToFind)
            XCTAssertEqual(foundObject?.id, idToFind)
        }
    }

}
