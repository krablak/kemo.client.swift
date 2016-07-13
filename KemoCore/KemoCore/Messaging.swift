//
//  Messaging.swift
//  KemoCore
//
//  Created by Michal Racek on 11/03/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation

/*
 Top level messaging API with communication and encryption.
 */
public class Messaging {

	// Reference to current client
	private var client: KemoClient!

	// Handler to pass received message
	private let onMessage: (message: String) -> Void

	// Function called on messaging state update
	public var onStateUpdate: (state: MessagingState) -> Void

	// Encryption key
	private var key: [UInt8]

	// Holds information about current messaging instance state
	public let state = MessagingState()

	lazy var stateTimer: NSTimer = {
		return NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(Messaging.updateTick), userInfo: nil, repeats: true)
	}()

	public init(key: String, onMessage: (message: String) -> Void) {
		log.debug("Creating new messaging component.")
		// Set empty state change update
		self.onStateUpdate = { state in }
		// Set on message handler
		self.onMessage = onMessage
		// Get key as bytes
		self.key = Conversions.toBytes(key)
		// Create session path from given key
		let sessionPath = DefaultEncryption.toSessionPath(Conversions.toBytes(key), saltFn: Salts.saltSessionPath)
		// Create client instance
		self.client = KemoClient(host: "kemoundertow-krablak.rhcloud.com", sessionPath: sessionPath, onMessage: self.onMessageInternal)
		// Connect in background thread
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
			self.client.connect()
		}
		// Start messaging state update timer
		self.stateTimer.fire()
	}

	public func checkConnection() {
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
			self.client.checkConnection()
		}
	}

	@objc public func updateTick() {
		dispatch_async(dispatch_get_main_queue()) {
			// Check connection
			self.client.checkConnection()
			// Update information about client state
			self.state.updateState(self.client.readyState)
			// Notify state update handler
			self.onStateUpdate(state: self.state)
		}
	}

	public func changeKey(key: String) {
		log.debug("Changing messaging key.")
		// Change key and reconnect in background thread
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
			self.key = Conversions.toBytes(key)

			// Disconnect current client
			log.debug("Shutting down current client")
			self.client.disconnect()

			// Create new client and connect
			log.debug("Creating new networking client instance.")
			let sessionPath = DefaultEncryption.toSessionPath(self.key, saltFn: Salts.saltSessionPath)
			self.client = KemoClient(host: "kemoundertow-krablak.rhcloud.com", sessionPath: sessionPath, onMessage: self.onMessageInternal)
			self.client.connect()

			// Update client state
			self.state.updateState(self.client.readyState)
		}
	}

	public func send(message: String) {
		log.debug("Sending message")
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
			let encryptedMessageBytes = DefaultEncryption.encrypt(self.key, keySaltFn: Salts.saltEncKey, data: Conversions.toBytes(message))
			let encryptedMessage = Conversions.toStr(encryptedMessageBytes)
			self.client.send(encryptedMessage)

			// Update client state
			self.state.updateWithSent(encryptedMessageBytes, state: self.client.readyState)
			// Notify state update handler
			self.onStateUpdate(state: self.state)

			log.debug("Message was sent")
		}
	}

	private func onMessageInternal(message: String) {
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
			log.debug("Receiving message")
			let messageBytes = Conversions.toBytes(message)

			// Update client state
			self.state.updateWithReceived(messageBytes, state: self.client.readyState)
			// Notify state update handler
			self.onStateUpdate(state: self.state)

			let decryptedBytes = DefaultEncryption.decrypt(self.key, keySaltFn: Salts.saltEncKey, data: messageBytes)
			let decryptedStr = Conversions.toStr(decryptedBytes)
			log.debug("Message was descrypted.")

			// Do not block messaging and pass message to handler in separate task
			dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
				log.debug("Passing to message handler as separate background task.")
				self.onMessage(message: decryptedStr)
				log.debug("Passed to handler.")
			}
		}

	}

}

/*
 Holds current messaging component state.
 */
public class MessagingState {

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

	func updateState(state: KemoClient.ReadyState) {
		self.clientState = state
	}

	func updateWithReceived(messageBytes: [UInt8], state: KemoClient.ReadyState) {
		self.clientState = state
		self.receivedMessagesCount += 1
		self.receivedBytes += messageBytes.count
		self.receivedDate = NSDate()
	}

	func updateWithSent(messageBytes: [UInt8], state: KemoClient.ReadyState) {
		self.clientState = state
		self.sentMessagesCount += 1
		self.sentBytes += messageBytes.count
		self.sentDate = NSDate()
	}

}
