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
public class SentMessageMarker {
	
	fileprivate var sentMessage = ""
	
	init() { }
	
	func isSent(_ message: String) -> Bool {
		return self.sentMessage == message
	}
	
	func markAsSent(_ message: String) {
		self.sentMessage = message
	}
	
}
