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
	private var key: String

	// Messaging path
	private var path: String

	public init(key: String, path: String, onMessage: (message: String) -> Void) {
		self.onMessage = onMessage
		self.key = key
		self.path = path
		// Create initial client
		self.client = KemoClient(host: "kemoundertow-krablak.rhcloud.com", sessionPath: path, onMessage: onMessage)
		
		
	}

	public func changeKey(key: String) {

	}

	public func send(message: String) {

	}

	public func onMessage(onMessage: (message: String) -> Void) {

	}

}
