//
//  AppDelegate.swift
//  KemoApp
//
//  Created by Michal Racek on 09/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Cocoa
import KemoCore

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		log.level = LoggerFacade.Level.OFF
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

