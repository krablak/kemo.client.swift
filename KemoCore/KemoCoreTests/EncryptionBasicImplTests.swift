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

		let decrypted = DefaultEncryption.decrypt(keyBytes, keySaltFn: Salts.saltEncKey, data: encrypted)
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

		let encryptedBytes = Conversions.toBytesFromBase64(encrypted)

		let decrypted = DefaultEncryption.decrypt(Conversions.toBytes(key), keySaltFn: Salts.saltEncKey, data: encryptedBytes)

		let decryptedStr = Conversions.toStr(decrypted)
		XCTAssertEqual(expectedDecrypted, decryptedStr)
	}

	func testEmptyPathProvide() {
		let key = ""
		let expectedPath = "ZIj69fen3Ef7i5hxT3TWQtXyi8B8mS7s7f6BysBy2rE%3D"

		let path = DefaultEncryption.toSessionPath(Conversions.toBytes(key), saltFn: Salts.saltSessionPath)
		XCTAssertEqual(expectedPath, path)
	}
	
	func testSimplePathProvide() {
		let key = "some simple key"
		let expectedPath = "Ct%2F2xnDU%2BIgUa6oo6A2Nwg36Zd8liJpbplBdZkPqXME%3D"
		
		let path = DefaultEncryption.toSessionPath(Conversions.toBytes(key), saltFn: Salts.saltSessionPath)
		XCTAssertEqual(expectedPath, path)
	}
	
	func testCZCharsPathProvide() {
		let key = "Nechť již hříšné saxofony ďáblů rozzvučí síň úděsnými tóny waltzu, tanga a quickstepu."
		let expectedPath = "IIchqOzYOmGO0NXbxWeQjs%2B9TO8OB2kZffm3zlRn7YU%3D"
		
		let path = DefaultEncryption.toSessionPath(Conversions.toBytes(key), saltFn: Salts.saltSessionPath)
		XCTAssertEqual(expectedPath, path)
	}

	func testEmojiCharsPathProvide() {
		let key = "😀😬😁😂😃😄😅😆😇😉😊🙂🙃☺️😋😌😍😘🙊🐒🐔🐧🐦🐤🐣🐥🐺🐗🐴🦄🐝🐛🐌🐞🐜🕷"
		let expectedPath = "ASEx4HxcRbSg1mL8xztUrQaVB3%2ByWC%2FcC%2Bu8RR9iFIw%3D"
		
		let path = DefaultEncryption.toSessionPath(Conversions.toBytes(key), saltFn: Salts.saltSessionPath)
		debugPrint(path)
		XCTAssertEqual(expectedPath, path)
	}

}

