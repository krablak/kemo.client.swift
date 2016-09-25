//
//  MessagingAddons.swift
//  KemoCore
//
//	Provides support components and function for building Messaging addons.
//
//  Created by Michal Racek on 16/07/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation

/*
 Basic empty implementation of Messaging addon as base for real MessagingAddon implementations.
 */
open class BasicMessagingAddon: MessagingAddon {

	open func messageWillSend(_ message: String) { }

	open func messageDidSend(_ encData: [UInt8]) { }

	open func messageWillReceive(_ encData: [UInt8]) { }

	open func messageDidReceive(_ message: String) { }

	open func onStateUpdate(_ state: KemoClient.ReadyState) { }

	open func onKeyChange(_ key: String) { }

}
