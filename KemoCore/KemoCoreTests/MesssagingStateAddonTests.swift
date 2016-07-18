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
	
	func testStateChange() {		
		func onStateChangeDifferent(oldState: KemoClient.ReadyState, newState: KemoClient.ReadyState){
			XCTAssertTrue(oldState != newState)
		}
		
		let stateAddon = MesssagingStateAddon()
		stateAddon.onStateChangeFns.insert(onStateChangeDifferent,atIndex: 0)
		
		stateAddon.onStateUpdate(KemoClient.ReadyState.CLOSED)
		stateAddon.onStateUpdate(KemoClient.ReadyState.CLOSING)
		stateAddon.onStateUpdate(KemoClient.ReadyState.CONNECTING)
	}

}
