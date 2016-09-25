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
open class MesssagingStateAddon: BasicMessagingAddon {

	// Kemo client state
	open var clientState: KemoClient.ReadyState = KemoClient.ReadyState.CLOSED

	// Count of all received messages
	open var receivedMessagesCount = 0

	// Count of sent messages
	open var sentMessagesCount = 0

	// Number of received bytes (before decryption)
	open var receivedBytes = 0

	// Number of send bytes (after encryption)
	open var sentBytes = 0

	// Date when was received last message
	open var receivedDate = Date()

	// Date when was received last message
	open var sentDate = Date()

	// Functions called in case of state change
	open var onStateChangeFns: [(_ stateAddon: MesssagingStateAddon) -> Void] = []

	override public init() { }

	override open func messageDidSend(_ encData: [UInt8]) {
		self.sentMessagesCount += 1
		self.sentBytes += encData.count
		self.sentDate = Date()
		for fn in onStateChangeFns { fn(self) }
	}

	override open func messageWillReceive(_ encData: [UInt8]) {
		self.receivedMessagesCount += 1
		self.receivedBytes += encData.count
		self.receivedDate = Date()
		for fn in onStateChangeFns { fn(self) }
	}

	override open func onStateUpdate(_ state: KemoClient.ReadyState) {
		self.clientState = state
		for fn in onStateChangeFns { fn(self) }
	}

}

