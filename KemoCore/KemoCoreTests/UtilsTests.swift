//
//  EncryptionUtilsTest.swift
//  KemoCore
//
//  Created by Michal Racek on 13/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import XCTest
import KemoCore

class EncryptionUtilsTest: XCTestCase {

	func testAsKey32() {
		XCTAssertEqual(32, asKey32([]).count)
		XCTAssertEqual(32, asKey32([1, 2, 3, 4, 5]).count)
		XCTAssertEqual(32, asKey32(generateByteArray(30)).count)
		XCTAssertEqual(32, asKey32(generateByteArray(30000)).count)
		XCTAssertNotEqual(asKey32([1, 2, 3, 4, 5]), asKey32([1, 2, 3, 4, 6]))
		XCTAssertNotEqual(asKey32([1, 2, 3, 4, 5]), asKey32([1, 3, 3, 4, 6]))
		XCTAssertEqual(asKey32([1, 2, 3, 4, 5]), asKey32([1, 2, 3, 4, 5]))
		let largeKey = generateByteArray(30000)
		XCTAssertEqual(asKey32(largeKey), asKey32(largeKey))
	}

	func testNaiveEncChain() {
		let key = generateByteArray(30)
		let data = generateByteArray(30000)
		
		let chain = naiveEncChain(key)
		let encData = chain.encrypt(data)
		let decData = chain.decrypt(encData)
		
		XCTAssertNotEqual(data, encData)
		XCTAssertEqual(data, decData)
	}
	
	func testPerformanceNaiveEncChain() {
		let key = generateByteArray(30)
		let data = generateByteArray(30000)
		
		self.measureBlock {
			let chain = naiveEncChain(key)
			let encData = chain.encrypt(data)
			chain.decrypt(encData)
		}
	}
}
