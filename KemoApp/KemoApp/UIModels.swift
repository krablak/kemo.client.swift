//
//  UIModels.swift
//  KemoApp
//
//  UI model related components and utilities.
//
//  Created by Michal Racek on 03/07/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation



/*
Mini-helper for marking and resolving sent messages.
*/
class SentMessageMarker {
	
	private var sentMessage = ""
	
	init() { }
	
	func isSent(message: String) -> Bool {
		return self.sentMessage == message
	}
	
	func markAsSent(message: String) {
		self.sentMessage = message
	}
	
}