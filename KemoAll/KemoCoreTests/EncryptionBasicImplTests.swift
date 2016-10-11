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

	private func dummySalt(key: [UInt8]) -> [UInt8] {
		return key
	}

	func testEncryptDecrypt() {
		let keyBytes = Conversions.toBytes("some key string")
		let dataBytes = Conversions.toBytes("sample data for encryption")
		let encrypted = DefaultEncryption.encrypt(keyBytes, keySaltFn: Salts.saltEncKey, data: dataBytes)

		XCTAssertNotEqual(dataBytes, encrypted)

		let decrypted = DefaultEncryption.decrypt(keyBytes, keySaltFn: Salts.saltEncKey, data: encrypted)
		XCTAssertEqual(dataBytes, decrypted)
	}

	func testEncryptDecryptEmojiAndCZData() {
		let keyBytes = Conversions.toBytes("😍😘🙊🐒🐔Nechť již hříšné saxofony ďáblů rozzvučí síň úděsnými tóny waltzu, tanga a quickstepu.😂😃😄😅😆😇😉")
		let dataBytes = Conversions.toBytes("😍😘🙊🐒🐔Nechť již hříšné saxofony ďáblů rozzvučí síň úděsnými tóny waltzu, tanga a quickstepu.😂😃😄😅😆😇😉")
		let encrypted = DefaultEncryption.encrypt(keyBytes, keySaltFn: Salts.saltEncKey, data: dataBytes)

		XCTAssertNotEqual(dataBytes, encrypted)
		debugPrint(Conversions.toStr(encrypted))

		let decrypted = DefaultEncryption.decrypt(keyBytes, keySaltFn: Salts.saltEncKey, data: encrypted)
		XCTAssertEqual(dataBytes, decrypted)
	}

	func testEncryptDecryptEmoji() {
		let keyBytes = Conversions.toBytes("😍")
		let dataBytes = Conversions.toBytes("😍")
		let encrypted = DefaultEncryption.encrypt(keyBytes, keySaltFn: Salts.saltEncKey, data: dataBytes)

		XCTAssertNotEqual(dataBytes, encrypted)
		debugPrint(Conversions.toStr(encrypted))

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
		let dataBytes = generateByteArray(length: 5000000)
		let encrypted = DefaultEncryption.encrypt(keyBytes, keySaltFn: Salts.saltEncKey, data: dataBytes)

		XCTAssertNotEqual(dataBytes, encrypted)

		let decrypted = DefaultEncryption.decrypt(keyBytes, keySaltFn: Salts.saltEncKey, data: encrypted)
		XCTAssertEqual(dataBytes, decrypted)
	}

	func testDecryptJSEncrypted_empty() {
		let key = ""
		let expectedDecrypted = ""
		let encrypted = "BNHOmO6taO0Nob9xqiiqIg=="

		let encryptedBytes = Conversions.toBytes(encrypted)

		let decrypted = DefaultEncryption.decrypt(Conversions.toBytes(key), keySaltFn: Salts.saltEncKey, data: encryptedBytes)

		let decryptedStr = Conversions.toStr(decrypted)
		XCTAssertEqual(expectedDecrypted, decryptedStr)
	}

	func testDecryptJSEncrypted_ascii() {
		let key = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
		let expectedDecrypted = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
		let encrypted = "+WtJHyVMEPB1gLzcrH0vOBnvSxcmbsm3+R8RjM5odhAgxSmYvdKrRPNuZWGZFyomztGlmoFDpd1Uzp3flPTCLjWoEaFIP3btIddiRcrtPKFk39TDhhCl/qrAqm2zgahk0vx9Z/zg9t4="

		let encryptedBytes = Conversions.toBytes(encrypted)
		let decrypted = DefaultEncryption.decrypt(Conversions.toBytes(key), keySaltFn: dummySalt, data: encryptedBytes)
		let decryptedStr = Conversions.toStr(decrypted)

		XCTAssertEqual(expectedDecrypted, decryptedStr)
	}

	func testDecryptJSEncrypted_singleCZChar() {
		let key = "a"
		let expectedDecrypted = "š"
		let encrypted = "yD6Cod2fADuDnydQ0GjLR4FjrRs="

		let encryptedBytes = Conversions.toBytes(encrypted)
		let decrypted = DefaultEncryption.decrypt(Conversions.toBytes(key), keySaltFn: dummySalt, data: encryptedBytes)
		let decryptedStr = Conversions.toStr(decrypted)

		XCTAssertEqual(expectedDecrypted, decryptedStr)
	}

	func testDecryptJSEncrypted_CZ() {
		let key = "Nechť již hříšné saxofony ďáblů rozzvučí síň úděsnými tóny waltzu, tanga a quickstepu."
		let expectedDecrypted = "Nechť již hříšné saxofony ďáblů rozzvučí síň úděsnými tóny waltzu, tanga a quickstepu."
		let encrypted = "y5DS+otpljUyYVtBUqPWqlQNt4f3sFXxEEiXgfdKL78f3KLX/+X2SDTP5HdbtMuBZYOz7mHyU/bwJbsinSXhocXifo8TlHUaP0tuYwnCgLl4Tb92HSO/0vlvL/Iy8Aw25H/HrUW26GUbKIZvCmeZC1l3AruD4vywkpvhqRpfDQwqHqRmly2NoyHvZTj6EzmZ+tkpZCXpFgtU845W"

		let encryptedBytes = Conversions.toBytes(encrypted)
		let decrypted = DefaultEncryption.decrypt(Conversions.toBytes(key), keySaltFn: dummySalt, data: encryptedBytes)
		let decryptedStr = Conversions.toStr(decrypted)

		XCTAssertEqual(expectedDecrypted, decryptedStr)
	}

	func testDecryptJSEncrypted_emoji() {
		let key = "😀😬😁😂😃😄😅😆😇😉😊🙂🙃☺️😋😌😍😘🙊🐒🐔🐧🐦🐤🐣🐥🐺🐗🐴🦄🐝🐛🐌🐞🐜🕷"
		let expectedDecrypted = "😀😬😁😂😃😄😅😆😇😉😊🙂🙃☺️😋😌😍😘🙊🐒🐔🐧🐦🐤🐣🐥🐺🐗🐴🦄🐝🐛🐌🐞🐜🕷"
		let encrypted = "ToHQL8+nR7uJhPDoMNNu24EybGb0yQYnFwSVN+zTq5k8JhcLKtUfb9JSli9o77+8Un/JuE6S+LUf8fFcyrEnNoB1nlYY//zSRFlmba552EzrQn5kepqFmK0uZyvedg81nh1w/jpAknQ/g3PPPNwzkR9aZElIc/BSgAInfUnOlnW2zHZ4bL/CDiFTz4AyQ650M4X8VmPY2CnGUA2HqRzB0cfu+6APfJPqQcp6upPRQoK6p/Fe2KQcdtu5Vs7pOITeZCndlg1J84PUlhj3tpWowzGdab4="

		let encryptedBytes = Conversions.toBytes(encrypted)
		let decrypted = DefaultEncryption.decrypt(Conversions.toBytes(key), keySaltFn: dummySalt, data: encryptedBytes)
		let decryptedStr = Conversions.toStr(decrypted)

		XCTAssertEqual(expectedDecrypted, decryptedStr)
	}

}

class SessionPathTests: XCTestCase {
	
	func testEmptyPathProvide() {
		let key = ""
		let expectedPath = "tO%2BK0BckFeNDo9FqP0o45T%2FOXezXXmctjTSwenoBObw%3D"
		
		let path = DefaultEncryption.toSessionPath(Conversions.toBytes(key), saltFn: Salts.saltSessionPath)
		XCTAssertEqual(expectedPath, path)
	}
	
	func testSingleCharPathProvide() {
		let key = "r"
		let expectedPath = "iUx7Yrz9M%2BJYYM0nR3LyITlIxT1LcgzI8DBTS4WDpP8%3D"
		
		let path = DefaultEncryption.toSessionPath(Conversions.toBytes(key), saltFn: Salts.saltSessionPath)
		XCTAssertEqual(expectedPath, path)
	}
	
	func testSimplePathProvide() {
		let key = "some simple key"
		let expectedPath = "SSw9K8FZxn%2BqFltVG3heTnAvetrKI%2FrSQBPAG%2FO%2BPNM%3D"
		
		let path = DefaultEncryption.toSessionPath(Conversions.toBytes(key), saltFn: Salts.saltSessionPath)
		XCTAssertEqual(expectedPath, path)
	}
	
	func testCZCharsPathProvide() {
		let key = "Nechť již hříšné saxofony ďáblů rozzvučí síň úděsnými tóny waltzu, tanga a quickstepu."
		let expectedPath = "wVk8GBflnEYNVHzGAeODYgTCNnvTiHdi7dodnbZwTKw%3D"
		
		let path = DefaultEncryption.toSessionPath(Conversions.toBytes(key), saltFn: Salts.saltSessionPath)
		XCTAssertEqual(expectedPath, path)
	}
	
	func testEmojiCharsPathProvide() {
		let key = "😀😬😁😂😃😄😅😆😇😉😊🙂🙃☺️😋😌😍😘🙊🐒🐔🐧🐦🐤🐣🐥🐺🐗🐴🦄🐝🐛🐌🐞🐜🕷"
		let expectedPath = "%2Bej2ag4aZ2BdJ%2FSWqnTMtTR3lX2l7%2Fwz3K6JrE4sRNk%3D"
		
		let path = DefaultEncryption.toSessionPath(Conversions.toBytes(key), saltFn: Salts.saltSessionPath)
		debugPrint(path)
		XCTAssertEqual(expectedPath, path)
	}
	
}



