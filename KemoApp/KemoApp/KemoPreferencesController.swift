//
//  PreferencesController.swift
//  KemoApp
//
//  Created by Michal Racek on 12/02/17.
//  Copyright © 2017 PyJunkies. All rights reserved.
//

import Foundation
import Cocoa
import KemoCore

// Controller responsible for loading and storing preferences values.
open class KemoPreferencesController: NSViewController, NSWindowDelegate {
	
	@IBOutlet weak var serverUrlFld: NSTextField!
	
	@IBOutlet weak var timeStampFld: NSButton!
	
	@IBOutlet weak var welcomeMsgFld: NSButton!
	
	// Load preferences on preferences window apper
	open override func viewWillAppear() {
		serverUrlFld!.stringValue = KemoPreferencesService.service.serverUrl()
		timeStampFld!.state = KemoPreferencesService.service.addTime() ? 1 : 0
		welcomeMsgFld!.state = KemoPreferencesService.service.connMessageEnabled() ? 1 : 0
	}
	
	// Save preferences setting on closing window
	open override func viewDidDisappear() {
		KemoPreferencesService.service.serverUrl(url: serverUrlFld!.stringValue)
		KemoPreferencesService.service.addTime(state: timeStampFld!.state)
		KemoPreferencesService.service.connMessageEnabled(state: welcomeMsgFld!.state)
	}
}
