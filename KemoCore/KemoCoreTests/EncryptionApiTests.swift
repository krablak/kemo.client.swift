//
//  EncruptionApiTests.swift
//  KemoCore
//
//  Created by Michal Racek on 09/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import XCTest
import KemoCore

class EncryptionApiTests: XCTestCase {

	func testEncryptionChainCreation() {
		let encChain = EncryptionChain()
		XCTAssertNotNil(encChain)
	}

	func testEncryptionChainWithDummyEncFunction() {
		let encChain = EncryptionChain().add(Dummy()).add(Dummy())
		XCTAssertNotNil(encChain)
		XCTAssertEqual([0, 1, 2, 3], encChain.decrypt([0, 1, 2, 3]))
		XCTAssertEqual([0, 1, 2, 3], encChain.encrypt([0, 1, 2, 3]))
	}

	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measureBlock {
			// Put the code you want to measure the time of here.
		}
	}
}
