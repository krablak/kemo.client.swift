//
//  EncryptionPartsTests.swift
//  KemoCore
//
//  Created by Michal Racek on 10/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import XCTest
import KemoCore

class SimpleEncryptionPartTests: EncryptionPartTest {

	func testSmallData() {
		self.smallData(SimpleEncryption(key: [0, 1, 2, 3, 4]))
	}

	func testLargeDataAndKey() {
		self.largeData(SimpleEncryption(key: generateByteArray(10000)))
	}
}

class AESEncryptionPartTests: EncryptionPartTest {

	func testSmallData() {
		self.smallData(AESEncryption(key: [0, 1, 2, 3, 4]))
	}

	func testLargeDataAndKey() {
		self.largeData(AESEncryption(key: generateByteArray(10000)))
	}
}

class KemoEncryptionPartTests: EncryptionPartTest {
	
	func testSmallData() {
		self.smallData(KemoEncryption(key: [0, 1, 2, 3, 4]))
	}
	
	func testLargeDataAndKey() {
		self.largeData(KemoEncryption(key: generateByteArray(10000)))
	}
}

