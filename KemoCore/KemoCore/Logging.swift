//
//  Logging.swift
//  KemoCore
//
//  Created by Michal Racek on 29/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation

import XCGLogger

let log = XCGLogger.defaultInstance()

public func initDevLogging() {
	log.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil, fileLogLevel: .Debug)
}
