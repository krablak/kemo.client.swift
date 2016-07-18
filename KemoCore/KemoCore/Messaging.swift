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

	// Encryption key
	private var key: [UInt8]

	// Timer for checking messaging state
	lazy var stateTimer: NSTimer = {
		return NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(Messaging.updateTick), userInfo: nil, repeats: true)
	}()

	// Messaging addon components extending basic messaging functionality
	public var addons: [MessagingAddon] = []

	public init(key: String, onMessage: (message: String) -> Void) {
		log.debug("Creating new messaging component.")
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

			// Propagate receive message to addons
			for addon in self.addons { addon.onStateUpdate(self.client.readyState) }
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

			// Propagate receive message to addons
			for addon in self.addons { addon.onStateUpdate(self.client.readyState) }
		}
	}

	public func send(message: String) {
		log.debug("Sending message")
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {

			// Propagate sending message to addons
			for addon in self.addons { addon.messageWillSend(message) }

			let encryptedMessageBytes = DefaultEncryption.encrypt(self.key, keySaltFn: Salts.saltEncKey, data: Conversions.toBytes(message))
			let encryptedMessage = Conversions.toStr(encryptedMessageBytes)
			self.client.send(encryptedMessage)

			// Propagate sent message to addons
			for addon in self.addons { addon.messageDidSend(encryptedMessageBytes) }

			// Propagate receive message to addons
			for addon in self.addons { addon.onStateUpdate(self.client.readyState) }

			log.debug("Message was sent")
		}
	}

	private func onMessageInternal(message: String) {
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
			log.debug("Receiving message")
			let messageBytes = Conversions.toBytes(message)

			// Propagate receive message to addons
			for addon in self.addons { addon.messageWillReceive(messageBytes) }

			// Propagate receive message to addons
			for addon in self.addons { addon.onStateUpdate(self.client.readyState) }

			let decryptedBytes = DefaultEncryption.decrypt(self.key, keySaltFn: Salts.saltEncKey, data: messageBytes)
			let decryptedStr = Conversions.toStr(decryptedBytes)
			log.debug("Message was descrypted.")

			// Do not block messaging and pass message to handler in separate task
			dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
				log.debug("Passing to message handler as separate background task.")
				self.onMessage(message: decryptedStr)

				// Propagate receive message to addons
				for addon in self.addons { addon.messageDidReceive(message) }

				log.debug("Passed to handler.")
			}

		}

	}

}

/*
 Defines method for messaging addon components.
 */
public protocol MessagingAddon {

	// Called when plain message will be sent
	func messageWillSend(message: String)

	// Called when encrypted data were send
	func messageDidSend(encData: [UInt8])

	// Called when encrypted data are received
	func messageWillReceive(encData: [UInt8])

	// Called when data were received and decrypted
	func messageDidReceive(message: String)

	// Called on possible state change
	func onStateUpdate(state: KemoClient.ReadyState)

	// Called before key change
	func onKeyChange(key: String)
}
