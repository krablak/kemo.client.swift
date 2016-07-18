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
public class BasicMessagingAddon: MessagingAddon {

	public func messageWillSend(message: String) { }

	public func messageDidSend(encData: [UInt8]) { }

	public func messageWillReceive(encData: [UInt8]) { }

	public func messageDidReceive(message: String) { }

	public func onStateUpdate(state: KemoClient.ReadyState) { }

	public func onKeyChange(key: String) { }

}