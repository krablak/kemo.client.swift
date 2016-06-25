//
//  ViewController.swift
//  Kemo
//
//  Created by Michal Racek on 06/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, UIComponents {

	let PRESENTATION_MODE = false

	@IBOutlet var messageTextView: ChatTextView!

	@IBOutlet weak var messageTextFld: NSTextField!

	@IBOutlet weak var kemoKeyFld: NSSecureTextField!

	@IBOutlet var mainView: NSView!

	@IBOutlet weak var messageTextScrollView: NSScrollView!

	@IBAction func onMessageEnter(sender: NSTextField) {
		// Add entered message into chat view
		self.messageTextView.addReceived(sender.stringValue)

		func updateMessages(messages: [String]) {
			debugPrint(messages)
		}

		// let session = MessagingSession(key: "hovnohovnohovno", serverConfig: ServerConfigs.LOCAL)
		// session.send(sender.stringValue, onReceived: updateMessages)

		// Clean message text field
		sender.stringValue = ""
	}

	// View theme instance
	var theme = UIThemeWhite()

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		// Apply theme on current view
		theme.apply(self)
		// Set theme to chat view
		self.messageTextView.theme = theme
		// Reset view content
		self.messageTextView.reset()

		// Initial values
		self.view.window?.title = "kemo.rocks"

		// View content for presentation mode
		if PRESENTATION_MODE {
			// Preview default values
			kemoKeyFld.stringValue = "some super secret key"

			self.messageTextView.addReceived("Hello?")
			self.messageTextView.addSent("Montag, here.")
			self.messageTextView.addReceived("Well... What sort were these then, Montag?")
			self.messageTextView.addSent("I didn't really look, sir. A little bit of everything.")
			self.messageTextView.addSent("Novels, biographies, adventure stories.")
			self.messageTextView.addReceived("Oh, routine, eh?")
			self.messageTextView.addReceived("Why will they do it? It's sheer perversity.")
			self.messageTextView.addReceived("What does Montag do with his day off duty?")
			self.messageTextView.addSent("Not very much, sir. Mow the lawn.")
			self.messageTextView.addReceived("And what if the law forbids that?")
			self.messageTextView.addSent("Just watch it grow, sir.")
			self.messageTextView.addReceived("Uh-huh.")
			self.messageTextView.addReceived("Good.")

			messageTextFld.stringValue = "Just watch it grow, sir."
		}
	}

	/*
	 UIComponents required functions.
	 */
	func getMainView() -> NSView {
		return self.mainView!
	}

	func getKeyField() -> NSSecureTextField {
		return self.kemoKeyFld
	}

	func getMessageTextView() -> NSTextView {
		return self.messageTextView
	}

	func getMessageField() -> NSTextField {
		return self.messageTextFld;
	}

	func getMessageTextScrollView() -> NSScrollView {
		return self.messageTextScrollView;
	}
}
