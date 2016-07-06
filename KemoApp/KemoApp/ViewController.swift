//
//  ViewController.swift
//  Kemo
//
//  Created by Michal Racek on 06/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Cocoa
import KemoCore

class ViewController: NSViewController, UIComponents, NSWindowDelegate {

	// Temporary flag for case of making screenshots filled content
	let PRESENTATION_MODE = false

	@IBOutlet var messageTextView: ChatTextView!

	@IBOutlet weak var messageTextFld: NSTextField!

	@IBOutlet weak var kemoKeyFld: NSSecureTextField!

	@IBOutlet weak var nickFld: NSTextField!

	@IBOutlet var mainView: NSView!

	@IBOutlet weak var messageTextScrollView: NSScrollView!

	// Instance of messaging component
	var messaging: Messaging?

	// Helper for identification of sent and received messages
	var sentMarker = SentMessageMarker()

	// View theme instance
	var theme = UIThemeWhite()

	@IBAction func onKeyChange(sender: NSSecureTextField) {
		self.messaging!.changeKey(sender.stringValue)
	}

	@IBAction func onMessageEnter(sender: NSTextField) {
		let message = nickFld.stringValue != "" ? "[\(nickFld.stringValue)] \(sender.stringValue)" : sender.stringValue
		// Try to send message
		self.messaging!.send(message)
		// Mark message as sent
		sentMarker.markAsSent(message)

		// Clean message text field
		sender.stringValue = ""
	}

	/*
	 Internal method for adding received message into chat view.
	 */
	private func onReceivedMessage(message: String) {
		// dispatch_sync(
		dispatch_async(dispatch_get_main_queue()) {
			if self.sentMarker.isSent(message) {
				self.messageTextView.addSent(message)
			} else {
				self.messageTextView.addReceived(message)
				if self.view.window != nil {
					Notifications.onReceived(message, window: self.view.window!)
				}
			}
		}
	}

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
		self.view.window?.delegate = self

		// Messaging with empty default key
		messaging = Messaging(key: "", onMessage: self.onReceivedMessage)

		// View content for presentation mode
		if PRESENTATION_MODE {
			fillWithConversation(self)
		}
	}

	/*
	 NSWindowDelegate methods.
	 */
	func windowDidBecomeKey(notification: NSNotification) {
		if self.view.window != nil {
			Notifications.hide(self.view.window!)
		}
	}

	/*
	 UIComponents required functions.
	 */
	func getMainView() -> NSView {
		return self.mainView!
	}

	func getNickFld() -> NSTextField {
		return self.nickFld
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
