//
//  StateAddons.swift
//  KemoApp
//
//  Created by Michal Racek on 15/02/17.
//  Copyright © 2017 PyJunkies. All rights reserved.
//

import Foundation
import KemoCore


// Sends message to all users about joining chat session
open class OnConnectedMessageAddon : BasicMessagingAddon {
	
	// Last known state
	var lastState = KemoClient.ReadyState.CLOSED
	
	// Function for sending message
	let sendMesageFn: (String)->Void
	let nickProviderFn: ()->String
	
	init(sendMesage: @escaping (String)->Void, nickProvider: @escaping ()->String) {
		self.sendMesageFn = sendMesage
		self.nickProviderFn = nickProvider
	}
	
	// Send message to other chat users that user was connected
	override open func onStateUpdate(_ state: KemoClient.ReadyState) {
		if KemoPreferencesService.service.connMessageEnabled() {
			if state != self.lastState && KemoClient.ReadyState.OPEN == state {
				let nick = self.nickProviderFn()
				self.sendMesageFn("\(nick) IS HERE!")
			}
		}
		self.lastState = state
	}
	
}
