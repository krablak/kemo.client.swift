//
//  UtilsConversionTest.swift
//  KemoCore
//
//  Created by Michal Racek on 08/03/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import XCTest
import KemoCore

class UtilsConversionTest: XCTestCase {

	func testBytesConverstions() {
		let bytes = Conversions.toBytes("01234")
		XCTAssertEqual([48, 49, 50, 51, 52], bytes)
		let bytesStr = Conversions.toStr(bytes)
		XCTAssertEqual("01234", bytesStr)
	}

	func testBase64Conversions() {
		let bytes = Conversions.toBytes("01234")
		let bytesAsBase64 = Conversions.toBase64Str(bytes)
		XCTAssertEqual("MDEyMzQ=", bytesAsBase64)
		let bytesStr = Conversions.toBytesFromBase64(bytesAsBase64)
		XCTAssertEqual(bytes, bytesStr)
	}

	func testWrongToBytesFromBase64() {
		let nonBase64Res = Conversions.toBytesFromBase64("non64bytes")
		XCTAssertEqual([], nonBase64Res)
	}

	func testToBytesFromHexStr() {
		XCTAssertEqual([0], Conversions.toBytesFromHexStr("00"))
		XCTAssertEqual([0, 1], Conversions.toBytesFromHexStr("0001"))
		XCTAssertEqual([0, 1, 10], Conversions.toBytesFromHexStr("00010A"))
		XCTAssertEqual([0, 1, 10, 255], Conversions.toBytesFromHexStr("00010AFF"))
		XCTAssertEqual([0, 1, 10, 255], Conversions.toBytesFromHexStr("00010AFFA"))
	}

	func testSingleEmoji() {
		let emojiString = "💂🏿"
		let emojiBytes = Conversions.toBytes(emojiString)
		let emojiBytesAsString = Conversions.toStr(emojiBytes)
		XCTAssertEqual(emojiString, emojiBytesAsString)
	}

	func testEmojis() {
		let emojiString = "😜😝🐰😜🐷"
		let emojiBytes = Conversions.toBytes(emojiString)
		let emojiBytesAsString = Conversions.toStr(emojiBytes)
		XCTAssertEqual(emojiString, emojiBytesAsString)
	}

	func testAnotherStrangeChar0() {
		let emojiString = "š"
		let emojiBytes = Conversions.toBytes(emojiString)
		let emojiBytesAsString = Conversions.toStr(emojiBytes)
		XCTAssertEqual(emojiString, emojiBytesAsString)
	}

	func testAsciiCharsBase64Conversions() {
		let srcText = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
		let expectedBase64 = "QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVphYmNkZWZnaGlqa2xtbm9wcXJzdHV2d3h5ejAxMjM0NTY3ODkrLz0="

		debugPrint(expectedBase64)
		let base64Str = Conversions.toBase64Str(Conversions.toBytes(srcText))

		XCTAssertEqual(expectedBase64, base64Str)
	}

	func testCCZCharsBase64Conversions() {
		XCTAssertEqual("TmVjaMWlIGppxb4gaMWZw63FoW7DqSBzYXhvZm9ueSDEj8OhYmzFryByb3p6dnXEjcOtIHPDrcWIIMO6ZMSbc27DvW1pIHTDs255IHdhbHR6dSwgdGFuZ2EgYSBxdWlja3N0ZXB1Lg==", Conversions.toBase64Str(Conversions.toBytes("Nechť již hříšné saxofony ďáblů rozzvučí síň úděsnými tóny waltzu, tanga a quickstepu.")))
	}

	func testEmojisBase64Conversions() {
		XCTAssertEqual("8J+YgPCfmKzwn5iB8J+YgvCfmIPwn5iE8J+YhfCfmIbwn5iH8J+YifCfmIrwn5mC8J+Zg+KYuu+4j/CfmIvwn5iM8J+YjfCfmJjwn5mK8J+QkvCfkJTwn5Cn8J+QpvCfkKTwn5Cj8J+QpfCfkLrwn5CX8J+QtPCfpoTwn5Cd8J+Qm/CfkIzwn5Ce8J+QnPCflbc=", Conversions.toBase64Str(Conversions.toBytes("😀😬😁😂😃😄😅😆😇😉😊🙂🙃☺️😋😌😍😘🙊🐒🐔🐧🐦🐤🐣🐥🐺🐗🐴🦄🐝🐛🐌🐞🐜🕷")))
	}

}

