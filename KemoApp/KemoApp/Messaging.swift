//
//  Messaging.swift
//  KemoApp
//
//  Created by Michal Racek on 12/03/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation
import KemoCore

public class MessagingSession {

	let serverConfig: ServerCfg
	let enryptionChain: EncryptionChain
	let locationKey: [UInt8]

	public init(key: String, serverConfig: ServerCfg) {
		self.serverConfig = serverConfig
		self.enryptionChain = EncryptionChain().add(Dummy())
		self.locationKey = Keys.toSimpleKey(key)
	}

	public func send(message: String, onReceived: (messages: [String]) -> Void) {
		func onReceivedData(data: [[UInt8]]) {
			// Read messages received from server
			var resMessages: [String] = []
			for dataPart in data {
				resMessages.append(Conversions.toStr(self.enryptionChain.decrypt(dataPart)))
			}
			// Pass them to
			onReceived(messages: resMessages)
		}

		// Prepare encrypted message data
		let encData = self.enryptionChain.encrypt(Conversions.toBytes(message))
		// Send message to server
		//sendAndCheck(self.serverConfig, key: self.locationKey, data: encData, onData: onReceivedData)
	}
}