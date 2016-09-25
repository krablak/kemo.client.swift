//
//  DummyLogger.swift
//  KemoLogger
//
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation


// Logger API facade with default dummy implementation
// Will be filled with real logger class later
open class LoggerFacade {
	
	public static func defaultInstance() -> LoggerFacade {
		return LoggerFacade()
	}
	
	public func debug(_ msg: String){
		debugPrint("DEBUG: \(msg)")
	}
	
	public func error(_ msg: String){
		debugPrint("ERROR: \(msg)")
	}
	
	public func info(_ msg: String){
		debugPrint("INFO: \(msg)")
	}
	
	public func warning(_ msg: String){
		debugPrint("WARN: \(msg)")
	}
	
}

