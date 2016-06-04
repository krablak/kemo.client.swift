//
//  EncryptionPartsTests.swift
//  KemoCore
//
//  Created by Michal Racek on 10/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import XCTest
import KemoCore

class DefaultEncryptionTests: XCTestCase {

	func testEncryptDecrypt() {
		let keyBytes = Conversions.toBytes("some key string")
		let dataBytes = Conversions.toBytes("sample data for encryption")
		let encrypted = DefaultEncryption.encrypt(keyBytes, keySaltFn: Salts.saltEncKey, data: dataBytes)

		XCTAssertNotEqual(dataBytes, encrypted)

		let decrypted = DefaultEncryption.decrypt(keyBytes, keySaltFn: Salts.saltEncKey, data: encrypted)
		XCTAssertEqual(dataBytes, decrypted)
	}

	func testEncryptDecryptEmptyData() {
		let keyBytes = Conversions.toBytes("some key string")
		let dataBytes = Conversions.toBytes("")
		let encrypted = DefaultEncryption.encrypt(keyBytes, keySaltFn: Salts.saltEncKey, data: dataBytes)

		XCTAssertNotEqual(dataBytes, encrypted)

		let decrypted = DefaultEncryption.decrypt(keyBytes,keySaltFn: Salts.saltEncKey, data: encrypted)
		XCTAssertEqual(dataBytes, decrypted)
	}

	func testEncryptDecryptEmptyDataAndKey() {
		let keyBytes = Conversions.toBytes("")
		let dataBytes = Conversions.toBytes("")
		let encrypted = DefaultEncryption.encrypt(keyBytes, keySaltFn: Salts.saltEncKey, data: dataBytes)

		XCTAssertNotEqual(dataBytes, encrypted)

		let decrypted = DefaultEncryption.decrypt(keyBytes, keySaltFn: Salts.saltEncKey, data: encrypted)
		XCTAssertEqual(dataBytes, decrypted)
	}

	func testEncryptDecryptLargeData() {
		let keyBytes = Conversions.toBytes("some key string")
		let dataBytes = generateByteArray(5000000)
		let encrypted = DefaultEncryption.encrypt(keyBytes, keySaltFn: Salts.saltEncKey, data: dataBytes)

		XCTAssertNotEqual(dataBytes, encrypted)

		let decrypted = DefaultEncryption.decrypt(keyBytes, keySaltFn: Salts.saltEncKey, data: encrypted)
		XCTAssertEqual(dataBytes, decrypted)
	}

	func testDecryptPythonEncrypted() {
		let key = "defaultKey"
		let expectedDecrypted = "encrypted message data"
		let encrypted = "Td0BEMdq54xCuOIufoTPR1UAlHaXVomKyoYeIZnLpQIaUM2WFOCnyTFlOsvMQVxy"

		// let kemoEncryption = KemoEncryption(key: Conversions.toBytes(key))
		let encryptedBytes = Conversions.toBytesFromBase64(encrypted)

		let decrypted = DefaultEncryption.decrypt(Conversions.toBytes(key), keySaltFn: Salts.saltEncKey, data: encryptedBytes)
		// let decrypted = kemoEncryption.decrypt(encryptedBytes)

		let decryptedStr = Conversions.toStr(decrypted)
		XCTAssertEqual(expectedDecrypted, decryptedStr)
	}

	func testSimplePathProvide() {
		XCTAssertEqual("APRanEHwMc3S2YHeqeoUaF2Wg3nTfwlQbU%2BLMinoMvA%3D", DefaultEncryption.toSessionPath(Conversions.toBytes("defaultKey"), saltFn: Salts.saltSessionPath))
		XCTAssertEqual("YnnuDrV70Yfz2lNFBTWd%2BfFUQ4uFskD9MWeFX0Wy1v8%3D", DefaultEncryption.toSessionPath(Conversions.toBytes(""), saltFn: Salts.saltSessionPath))
	}

}

