//
//  NetworkingTests.swift
//  KemoCore
//
//  Created by Michal Racek on 05/03/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import XCTest
import KemoCore

class NetworkingTests: XCTestCase {

	func testKemoClientSingleMessage() {
		let asyncExpectation = expectationWithDescription("longRunningFunction")

		func onReceivedMessage(message: String) {
			debugPrint("Received message: '\(message)'")
			asyncExpectation.fulfill()
		}

		let kemoClient = KemoClient(host: "kemoundertow-krablak.rhcloud.com", sessionPath: "test", onMessage: onReceivedMessage)
		kemoClient.connect()
		kemoClient.send("test message")

		self.waitForExpectationsWithTimeout(10) { error in
			debugPrint(asyncExpectation)
			XCTAssertTrue(true)
		}
		kemoClient.disconnect()
	}

	func testKemoClientMultipleMessages() {
		let asyncExpectation = expectationWithDescription("longRunningFunction")

		func onReceivedMessage(message: String) {
			debugPrint("Received message: '\(message)'")
			asyncExpectation.fulfill()
		}

		let kemoClient = KemoClient(host: "kemoundertow-krablak.rhcloud.com", sessionPath: "test", onMessage: onReceivedMessage)
		kemoClient.connect()
		for i in 1 ... 50 {
			kemoClient.send("test message '\(i)'")
		}

		self.waitForExpectationsWithTimeout(10) { error in
			debugPrint(asyncExpectation)
			XCTAssertTrue(true)
		}
		kemoClient.disconnect()
	}

}

