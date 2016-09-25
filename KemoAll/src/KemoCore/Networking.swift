//
//  HttpNetworking.swift
//  KemoCore
//
//  Created by Michal Racek on 16/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation
import Starscream

// Temporary disabled due to missing XCGLogger version for Swift 3
// import XCGLogger

/**
 kemo.rocks client API.
 */
open class KemoClient: WebSocketDelegate {

	/*
	 Websocket state inspired by https://developer.mozilla.org/en-US/docs/Web/API/WebSocket ready state constants.
	 */
	public enum ReadyState: String {
		// The connection is not yet open.
		case CONNECTING
		// The connection is open and ready to communicate.
		case OPEN
		// The connection is in the process of closing.
		case CLOSING
		// The connection is closed or couldn't be opened.
		case CLOSED
	}

	/*
	 Send operation result type.
	 */
	enum SEND_RESULT {
		// Message was sent
		case ok
		// Client need reconnection
		case need_RECONNECT
	}

	// WebSocket client instance
	fileprivate var socket: WebSocket

	// Function called on received message
	fileprivate var onMessage: (_ message: String) -> Void

	// Function called on changed connection state
	open var onConnectionChange: (_ state: ReadyState) -> Void

	// Messages queued when client was not yet connected
	fileprivate var sendQueue: [String] = []

	// Client state
	fileprivate(set) var readyState: ReadyState = ReadyState.CLOSED

	public init(host: String, sessionPath: String, onMessage: @escaping (_ message: String) -> Void) {
		log.debug("Creating kemo.client for host '\(host)' and session path '\(sessionPath)'")
		self.socket = WebSocket(url: URL(string: "wss://\(host):8443/messaging/\(sessionPath)")!)
		self.onMessage = onMessage
		self.onConnectionChange = { state in }
		self.socket.delegate = self
	}

	open func connect() {
		log.debug("Connecting...")
		self.readyState = ReadyState.CONNECTING
		self.socket.connect()
	}

	open func disconnect() {
		log.debug("Disconnecting...")
		self.readyState = ReadyState.CLOSING
		self.socket.disconnect()
		log.debug("Removing on message function")
		self.onMessage = { String in }
	}

	open func send(_ message: String) {
		if (self.readyState == .OPEN) {
			self.socket.write(string: message)
		} else {
			if (self.readyState == .CONNECTING) {
				// Check size of send queue
				if (self.sendQueue.count < 100) {
					// Add message to queue to be executed when client will be connected
					self.sendQueue.append(message)
					log.debug("Client state is '\(self.readyState.rawValue)'")
				} else {
					log.warning("Send queue is full and new messages cannot be accepted.")
				}
			} else {
				log.warning("Client state is '\(self.readyState.rawValue)' and message sending cannot be planned.")
			}
		}
	}

	open func checkConnection() {
		log.debug("Checking connection fo client.")
		// Check the state
		if (self.readyState == .OPEN) {
			log.debug("Client connection is open. Check complete.")
		} else if (self.readyState == .CONNECTING) {
			log.debug("Client is connecting right now. Check complete.")
		} else if (self.readyState == .CLOSING) {
			log.debug("Client is closing right now. Check complete.")
		} else {
			log.debug("Client is closed and needs to be connected.")
			self.connect()
			log.debug("Connection performed. Client state: '\(self.readyState.rawValue)' ")
		}
	}

	// When connected sends PING request to server
	open func ping() {
		log.debug("Connection ping.")
		if (self.readyState == .OPEN) {
			self.socket.write(ping: Data())
			log.debug("PING sent to server.")
		} else {
			log.debug("Client is not connected and PING was skipped.")
		}
	}

	open func websocketDidConnect(socket: WebSocket) {
		log.debug("Connected socket: '\(socket)'")
		// Check queued messages passed to not connected client
		while (self.sendQueue.count > 0) {
			log.debug("Sending queued message")
			let queuedMessage = self.sendQueue.popLast()
			if (queuedMessage != nil) {
				self.socket.write(string: queuedMessage!)
			}
		}
		// Set proper inner state
		self.readyState = ReadyState.OPEN
		self.onConnectionChange(self.readyState)
		log.debug("Ready state changed to '\(self.readyState.rawValue)'")
	}

	open func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
		log.debug("Disconnected socket: '\(socket)' with error: '\(error)'")
		self.readyState = ReadyState.CLOSED
		self.onConnectionChange(self.readyState)
	}

	open func websocketDidReceiveMessage(socket: WebSocket, text: String) {
		self.onMessage(text)
		self.onConnectionChange(self.readyState)
	}

	open func websocketDidReceiveData(socket: WebSocket, data: Data) {
		log.warning("Received data but data receiving feature is not supported.")
	}

}

