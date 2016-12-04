//
//  ViewController.swift
//  Kemo
//
//  Created by Michal Racek on 06/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Cocoa
import KemoCore

open class ViewController: NSViewController, NSWindowDelegate {
	
	// View theme instance
	var theme = UIThemeWhite()

	// Temporary flag for case of making screenshots filled content
	let PRESENTATION_MODE = false
	
	@IBOutlet weak var innerScrollView: NSView!
	
	@IBOutlet weak var kemoListView: KemoListView!

	@IBOutlet weak var messageTextFld: NSTextField!

	@IBOutlet weak var kemoKeyFld: NSSecureTextField!

	@IBOutlet weak var nickFld: NSTextField!

	@IBOutlet var mainView: NSView!

	@IBOutlet weak var kemoListScrollView: NSScrollView!
	
	@IBOutlet weak var infoBtn: NSButton!
	
	@IBOutlet weak var innerView: NSClipView!
	
	// Instance of messaging component
	lazy var messaging: Messaging = {
		// Messaging with empty default key
		var newMessaging = Messaging(key: "", onMessage: self.onReceivedMessage)
		// Add messaging state addon to observe
		newMessaging.addons.append(self.stateAddon)
		return newMessaging
	}()
	
	// Messaging state addon
	let stateAddon = MesssagingStateAddon()

	// Helper for identification of sent and received messages
	var sentMarker = SentMessageMarker()

	// Popover with messaging state/statistics
	var popover: NSPopover!

	// Info button click shows/hides popover with messaging state and statistics
	@IBAction func infoBtnClick(_ sender: NSButton) {
		if (popover.isShown) {
			popover.close()
		} else {
			popover.show(relativeTo: NSZeroRect, of: sender, preferredEdge: NSRectEdge.minY)
		}
	}

	@IBAction func onKeyChange(_ sender: NSSecureTextField) {
		self.messaging.changeKey(sender.stringValue)
	}

	@IBAction func onMessageEnter(_ sender: NSTextField) {
		let message = nickFld.stringValue != "" ? "[\(nickFld.stringValue)] \(sender.stringValue)" : sender.stringValue
		// Try to send message
		self.messaging.send(message)
		// Mark message as sent
		sentMarker.markAsSent(message)
		// Clean message text field
		sender.stringValue = ""
	}

	/*
	 Internal method for adding received message into chat view.
	 */
	fileprivate func onReceivedMessage(_ message: String) {
		// dispatch_sync(
		DispatchQueue.main.async {
			if self.sentMarker.isSent(message) {
				self.kemoListView.addLine(lineView: KemoListLineView.sent(message))
			} else {
				self.kemoListView.addLine(lineView: KemoListLineView.received(message))
				if self.view.window != nil {
					Notifications.onReceived(message, window: self.view.window!)
				}
			}
		}
	}

	override open func viewDidLoad() {
		super.viewDidLoad()
		// Init infoview popover
		self.popover = infoViewPopover(self)
	}

	override open func viewDidAppear() {
		super.viewDidAppear()

		// Apply theme on current view
		theme.apply(self)
		// Set theme to chat view
		self.kemoListView.theme = theme
		// Reset view content
		self.kemoListView.reset()

		// Initial values
		self.view.window?.title = "kemo.rocks"
		self.view.window?.delegate = self
		
		// Update info button icon
		self.updateInfoBtn()

		// View content for id mode
		if PRESENTATION_MODE {
			fillWithConversation(self)
		}

		// Check messaging connection on view appearance
		self.messaging.checkConnection()
	}
	
	// Updates state of info view button
	open func updateInfoBtn(){
		DispatchQueue.main.async {
			if self.stateAddon.clientState == .OPEN {
				self.infoBtn.image = NSImage.init(named: "NSStatusAvailable")
			} else if self.stateAddon.clientState == .CLOSING || self.stateAddon.clientState == .CLOSED {
				self.infoBtn.image = NSImage.init(named: "NSStatusUnavailable")
			} else if self.stateAddon.clientState == .CONNECTING {
				self.infoBtn.image = NSImage.init(named: "NSStatusPartiallyAvailable")
			} else {
				self.infoBtn.image = NSImage.init(named: "NSStatusNone")
			}
		}
	}

	/*
	 NSWindowDelegate methods.
	 */
	open func windowDidBecomeKey(_ notification: Notification) {
		if self.view.window != nil {
			Notifications.hide(self.view.window!)
		}
	}
}
