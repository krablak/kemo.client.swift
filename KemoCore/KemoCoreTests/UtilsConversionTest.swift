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
}

