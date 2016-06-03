//
//  MessagingTests.swift
//  KemoCore
//
//  Created by Michal Racek on 31/05/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import XCTest
import KemoCore

class MessagingTests: XCTestCase {

	func testSendAndReceiveMessage() {
		let asyncExpectation = expectationWithDescription("longRunningFunction")
		func onReceivedMessage(message: String) {
			debugPrint("Received message: \(message)")
			asyncExpectation.fulfill()
		}
		
		let messaging = Messaging(key: "test", onMessage: onReceivedMessage);
		
		
		messaging.send("swift message content")
		
		self.waitForExpectationsWithTimeout(10000) { error in
			debugPrint(asyncExpectation)
			XCTAssertTrue(true)
		}
	}

}
