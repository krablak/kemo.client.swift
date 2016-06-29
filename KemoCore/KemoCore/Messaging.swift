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
	private var client: KemoClient?

	// Handler to pass received message
	private let onMessage: (message: String) -> Void

	// Encryption key
	private var key: [UInt8]

	public init(key: String, onMessage: (message: String) -> Void) {
		log.debug("Creating new messaging component.")
		self.onMessage = onMessage
		// Get key as bytes
		self.key = Conversions.toBytes(key)
		// Create session path from given key
		let sessionPath = DefaultEncryption.toSessionPath(Conversions.toBytes(key), saltFn: Salts.saltSessionPath)
		// Connect in background thread
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
			// Create initial client instance
			self.client = KemoClient(host: "kemoundertow-krablak.rhcloud.com", sessionPath: sessionPath, onMessage: self.onMessageInternal)
			self.client?.connect()
		}
	}

	public func changeKey(key: String) {
		log.debug("Changing messaging key.")
		// Change key and reconnect in background thread
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
			self.key = Conversions.toBytes(key)

			// Disconnect current client
			log.debug("Shutting down current client")
			self.client?.disconnect()

			// Create new client and connect
			log.debug("Creating new networking client instance.")
			let sessionPath = DefaultEncryption.toSessionPath(self.key, saltFn: Salts.saltSessionPath)
			self.client = KemoClient(host: "kemoundertow-krablak.rhcloud.com", sessionPath: sessionPath, onMessage: self.onMessageInternal)
			self.client?.connect()
		}
	}

	public func send(message: String) {
		log.debug("Sending message")
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
			let encryptedMessageBytes = DefaultEncryption.encrypt(self.key, keySaltFn: Salts.saltEncKey, data: Conversions.toBytes(message))
			let encryptedMessage = Conversions.toBase64Str(encryptedMessageBytes)
			self.client?.send(encryptedMessage)
			log.debug("Message was sent")
		}
	}

	private func onMessageInternal(message: String) {
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
			log.debug("Receiving message")
			let messageBytes = Conversions.toBytesFromBase64(message)
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
