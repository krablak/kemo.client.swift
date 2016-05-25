//
//  EncryptionPartsTests.swift
//  KemoCore
//
//  Created by Michal Racek on 10/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import XCTest
import KemoCore


class KemoEncryptionPartTests: EncryptionPartTest {
	
	func testSmallData() {
		self.smallData(KemoEncryption(key: [0, 1, 2, 3, 4]))
	}
	
	func testLargeDataAndKey() {
		self.largeData(KemoEncryption(key: generateByteArray(10000)))
	}
}

