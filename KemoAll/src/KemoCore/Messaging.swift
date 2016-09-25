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
open class Messaging {

	// Reference to current client
	fileprivate var client: KemoClient!

	// Handler to pass received message
	fileprivate let onMessage: (_ message: String) -> Void

	// Encryption key
	fileprivate var key: [UInt8]

	// Timer for checking messaging state
	lazy var stateTimer: Timer = {
		return Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(Messaging.updateTick), userInfo: nil, repeats: true)
	}()

	// Timer for pinging server when connected to ensure that connection is alive
	lazy var pingTimer: Timer = {
		return Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(Messaging.pingConnected), userInfo: nil, repeats: true)
	}()

	// Messaging addon components extending basic messaging functionality
	open var addons: [MessagingAddon] = []

	public init(key: String, onMessage: @escaping (_ message: String) -> Void) {
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
		DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
			// Check connection on client state check
			self.client.onConnectionChange = { state in
				DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
					for addon in self.addons { addon.onStateUpdate(state) }
				}
			}
			// Connect
			self.client.connect()
		}
		// Start messaging state update timer
		self.stateTimer.fire()
		// Start ping timer
		pingTimer.fire();
	}

	open func checkConnection() {
		DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
			self.client.checkConnection()
		}
	}

	@objc open func updateTick() {
		DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
			self.client.checkConnection()
			// Propagate receive message to addons
			for addon in self.addons { addon.onStateUpdate(self.client.readyState) }
		}
	}

	@objc open func pingConnected() {
		DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
			// Check connection
			self.client.ping()
		}
	}

	open func changeKey(_ key: String) {
		log.debug("Changing messaging key.")
		// Change key and reconnect in background thread
		DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
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

	open func send(_ message: String) {
		log.debug("Sending message")
		DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {

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

	fileprivate func onMessageInternal(_ message: String) {
		DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
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
			DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
				log.debug("Passing to message handler as separate background task.")
				self.onMessage(decryptedStr)

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
	func messageWillSend(_ message: String)

	// Called when encrypted data were send
	func messageDidSend(_ encData: [UInt8])

	// Called when encrypted data are received
	func messageWillReceive(_ encData: [UInt8])

	// Called when data were received and decrypted
	func messageDidReceive(_ message: String)

	// Called on possible state change
	func onStateUpdate(_ state: KemoClient.ReadyState)

	// Called before key change
	func onKeyChange(_ key: String)
}
