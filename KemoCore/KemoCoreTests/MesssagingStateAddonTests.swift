//
//  MesssagingStateAddonTests.swift
//  KemoCore
//
//  Created by Michal Racek on 18/07/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import XCTest
import KemoCore

class MesssagingStateAddonTests: XCTestCase {

	func testSendReceive() {
		let data = "test message"
		let dataBytes: [UInt8] = Conversions.toBytes(data)

		let stateAddon = MesssagingStateAddon()
		
		func onChange(stateAddon: MesssagingStateAddon){
			XCTAssertTrue(true)
		}
		stateAddon.onStateChangeFns.append(onChange)

		// Send message string(no effect)
		stateAddon.messageDidReceive(data)
		XCTAssertEqual(0, stateAddon.sentMessagesCount)
		XCTAssertEqual(0, stateAddon.sentBytes)
		
		// Send message bytes
		stateAddon.messageDidSend(dataBytes)
		stateAddon.messageDidSend(dataBytes)

		// Receive message
		stateAddon.messageWillReceive(dataBytes)
		stateAddon.messageWillReceive(dataBytes)
		stateAddon.messageWillReceive(dataBytes)

		XCTAssertEqual(2, stateAddon.sentMessagesCount)
		XCTAssertEqual(2 * dataBytes.count, stateAddon.sentBytes)
		
		XCTAssertEqual(3, stateAddon.receivedMessagesCount)
		XCTAssertEqual(3 * dataBytes.count, stateAddon.receivedBytes)
	}

}
