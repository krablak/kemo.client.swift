//
//  MessagingStateAddon.swift
//  KemoCore
//
//  Created by Michal Racek on 17/07/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation

/*
 Holds and updates messaging state information.
 */
public class MesssagingStateAddon: BasicMessagingAddon {

	// Kemo client state
	public var clientState: KemoClient.ReadyState = KemoClient.ReadyState.CLOSED

	// Count of all received messages
	public var receivedMessagesCount = 0

	// Count of sent messages
	public var sentMessagesCount = 0

	// Number of received bytes (before decryption)
	public var receivedBytes = 0

	// Number of send bytes (after encryption)
	public var sentBytes = 0

	// Date when was received last message
	public var receivedDate = NSDate()

	// Date when was received last message
	public var sentDate = NSDate()

	// Functions called in case of state change
	public var onStateChangeFns: [(oldState: KemoClient.ReadyState, newState: KemoClient.ReadyState) -> Void] = []

	override public init() { }

	override public func messageDidSend(encData: [UInt8]) {
		self.sentMessagesCount += 1
		self.sentBytes += encData.count
		self.sentDate = NSDate()
	}

	override public func messageWillReceive(encData: [UInt8]) {
		self.receivedMessagesCount += 1
		self.receivedBytes += encData.count
		self.receivedDate = NSDate()
	}

	override public func onStateUpdate(state: KemoClient.ReadyState) {
		let oldState = self.clientState
		// Call state change handler only when state is changed
		if state != oldState {
			for fn in onStateChangeFns { fn(oldState: oldState, newState: state) }
		}
		self.clientState = state
	}

}

