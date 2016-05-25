//
//  TestUtils.swift
//  KemoCore
//
//  Created by Michal Racek on 13/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import XCTest
import Foundation
import KemoCore

class EncryptionPartTest: XCTestCase {

	func smallData(encPart: EncryptionPart) {
		let data: [UInt8] = [0, 1, 2, 3, 4, 5, 6]

		let encData = encPart.encrypt(data)
		XCTAssertNotEqual(data, encData)

		let decData = encPart.decrypt(encData)
		XCTAssertEqual(decData, data)
	}

	func largeData(encPart: EncryptionPart) {
		let data: [UInt8] = generateByteArray(1000000)

		let encData = encPart.encrypt(data)
		XCTAssertNotEqual(data, encData)

		let decData = encPart.decrypt(encData)
		XCTAssertEqual(decData, data)
	}

	func emptyData(encPart: EncryptionPart) {
		let data: [UInt8] = []

		let encData = encPart.encrypt(data)
		XCTAssertNotEqual(data, encData)

		let decData = encPart.decrypt(encData)
		XCTAssertEqual(decData, data)
	}
}

func generateByteArray(length: Int) -> [UInt8] {
	var genData: [UInt8] = []
	for _ in 0 ... length {
		genData.append(UInt8.init(truncatingBitPattern: arc4random_uniform(255)))
	}
	return genData
}