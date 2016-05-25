//
//  HttpNetworking.swift
//  KemoCore
//
//  Created by Michal Racek on 16/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation
import Starscream
import XCGLogger

/**
 kemo.rocks client API.
 */
public class KemoClient: WebSocketDelegate {

	/*
	 Websocket state inspired by https://developer.mozilla.org/en-US/docs/Web/API/WebSocket ready state constants.
	 */
	enum ReadyState {
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
		case OK
		// Client need reconnection
		case NEED_RECONNECT
	}

	// WebSocket client instance
	private var socket: WebSocket

	// Function called on received message
	private let onMessage: (message: String) -> Void

	// Messages queued when client was not yet connected
	private var sendQueue: [String] = []

	// Client state
	private var readyState: ReadyState = ReadyState.CLOSED

	public init(host: String, sessionPath: String, onMessage: (message: String) -> Void) {
		log.debug("Creating kemo.client for host '\(host)' and session path '\(sessionPath)'")
		self.socket = WebSocket(url: NSURL(string: "wss://\(host):8443/messaging/\(sessionPath)")!)
		self.onMessage = onMessage
		self.socket.delegate = self
	}

	public func connect() {
		log.debug("Connecting...")
		self.readyState = ReadyState.CONNECTING
		self.socket.connect()
	}

	public func disconnect() {
		log.debug("Disconnecting...")
		self.readyState = ReadyState.CLOSING
		self.socket.disconnect()
	}

	public func send(message: String) {
		if (self.readyState == .OPEN) {
			self.socket.writeString(message)
		} else {
			if (self.readyState == .CONNECTING) {
				// Check size of send queue
				if (self.sendQueue.count < 100) {
					// Add message to queue to be executed when client will be connected
					self.sendQueue.append(message)
				} else {
					log.warning("Send queue is full and new messages cannot be accepted.")
				}
			} else {
				log.warning("Client state is '\(self.readyState)' and message sending cannot be planned.")
			}
		}
	}

	public func checkConnection() {
		log.debug("Checking connection fo client.")
		if (self.readyState == .OPEN) {
			log.debug("Client connection is open. Check complete.")
		} else if (self.readyState == .CONNECTING) {
			log.debug("Client is connecting right now. Check complete.")
		} else {

		}
	}

	public func websocketDidConnect(socket: WebSocket) {
		log.debug("Connected socket: '\(socket)'")
		// Check queued messages passed to not connected client
		while (self.sendQueue.count > 0) {
			log.debug("Sending queued message")
			let queuedMessage = self.sendQueue.popLast()
			if (queuedMessage != nil) {
				self.socket.writeString(queuedMessage!)
			}
		}
	}

	public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
		log.debug("Disconnected socket: '\(socket)' with error: '\(error)'")
		self.readyState = ReadyState.CLOSED
	}

	public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
		self.onMessage(message: text)
	}

	public func websocketDidReceiveData(socket: WebSocket, data: NSData) {
		log.warning("Received data but data receiving feature is not supported.")
	}

}

