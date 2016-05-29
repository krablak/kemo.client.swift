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

class PythonCompatiblityTests: XCTestCase {

	func testDecryptPythonEncrypted() {
		let key = "clientenc" + "defaultKey" + "salt"
		let expectedDecrypted = "encrypted message data"
		let encrypted = "Td0BEMdq54xCuOIufoTPR1UAlHaXVomKyoYeIZnLpQIaUM2WFOCnyTFlOsvMQVxy"

		let kemoEncryption = KemoEncryption(key: Conversions.toBytes(key))
		let encryptedBytes = Conversions.toBytesFromBase64(encrypted)
		let decrypted = kemoEncryption.decrypt(encryptedBytes)

		let decryptedStr = Conversions.toStr(decrypted)
		XCTAssertEqual(expectedDecrypted, decryptedStr)
	}

}

class KemoSessionPathProviderTests: XCTestCase {

	func testSimpleKey() {
		XCTAssertEqual("APRanEHwMc3S2YHeqeoUaF2Wg3nTfwlQbU%2BLMinoMvA%3D", KemoSessionPathProvider().provide(Conversions.toBytes("defaultKey")))
	}

	func testEmptyPath() {
		XCTAssertEqual("YnnuDrV70Yfz2lNFBTWd%2BfFUQ4uFskD9MWeFX0Wy1v8%3D", KemoSessionPathProvider().provide(Conversions.toBytes("")))
	}
}

