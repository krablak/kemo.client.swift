//
//  CommonUtils.swift
//  KemoApp
//
//  Created by Michal Racek on 14/02/17.
//  Copyright © 2017 PyJunkies. All rights reserved.
//

import Foundation

// Message time formatter
let timeFormatter: DateFormatter = {
	let lazyFormatter = DateFormatter()
	lazyFormatter.dateFormat = "HH:mm:ss"
	return lazyFormatter
}()

// Add formatted time before message
func addTimeStamp(_ message: String) -> String{
	return "[\(timeFormatter.string(from: Date()))] \(message)"
}
