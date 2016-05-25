//
//  ViewController.swift
//  Kemo
//
//  Created by Michal Racek on 06/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Cocoa
import KemoCore

class ViewController: NSViewController {

	@IBOutlet var messageTextView: NSTextView!

	/**
	 Called in case when send mesage action is started.

	 - Parameter sender: Text field with message

	 */
	@IBAction func onMessageEnter(sender: NSTextField) {
		debugPrint("" + sender.stringValue)
		// Add entered message into chat view

		let attrString = NSAttributedString(string: sender.stringValue + "\n")
		self.messageTextView.textStorage?.appendAttributedString(attrString)

		func updateMessages(messages: [String]) {
			debugPrint(messages)
		}

		let session = MessagingSession(key: "hovnohovnohovno", serverConfig: ServerConfigs.LOCAL)
		session.send(sender.stringValue, onReceived: updateMessages)

		// Clean message text field
		sender.stringValue = ""
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		debugPrint(self)
	}

	override func viewDidAppear() {
		super.viewDidAppear()
	}

	override var representedObject: AnyObject? {
		didSet {
			// Update the view, if already loaded.
		}
	}
}
