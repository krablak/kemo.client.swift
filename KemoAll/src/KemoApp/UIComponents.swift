//
//  ChatTextView.swift
//  KemoApp
//
//  Created by Michal Racek on 22/06/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation
import Cocoa

/*
 Implementation of NSTextView hiding ugly details related to chat specific operations.
 */
open class ChatTextView: NSTextView {

	// View theme instance with default white theme
	open var theme = UIThemeWhite()

	// Minimal number of lines required to fill whole screen
	fileprivate static let CLEAN_UP_LINES_COUNT = 100

	// Maximal number of lines displayed by chat text view
	fileprivate static let MAX_LINES = CLEAN_UP_LINES_COUNT

	// Helper holding chat lines strings
	fileprivate var lines: [NSAttributedString] = []

	/*
	 Removes whole content and scrolls down.
	 */
	open func reset() {
		// Clean up all text in view
		self.textStorage?.mutableString.setString("")
		// Fill with empty lines
		for _ in 1 ... ChatTextView.CLEAN_UP_LINES_COUNT {
			addMessage("", attributes: theme.sentTextAttrs())
		}
		// Scroll to end
		self.isVerticallyResizable = true
		self.isHorizontallyResizable = true
		self.scrollToEndOfDocument(self)
	}

	/*
	 Adds message sent out to chat text view.
	 */
	open func addSent(_ message: String) {
		addMessage(message, attributes: theme.sentTextAttrs())
	}

	/*
	 Adds received message to chat text view.
	 */
	open func addReceived(_ message: String) {
		addMessage(message, attributes: theme.receiveTextAttrs())
	}

	/*
	 Internal implementation of adding message into view.
	 */
	fileprivate func addMessage(_ message: String, attributes: [String: AnyObject]) {
		// Create lined message from given string
		let lineMessage = NSMutableAttributedString(string: "\n\(message)", attributes: attributes)
		// Add message to known lines
		self.lines.append(lineMessage)
		// Remove old messages when maximal count of messages is exceeded
		if self.lines.count > ChatTextView.MAX_LINES {
			// Get oldest added line we know
			let lastMesage = self.lines.removeFirst()
			// Remove oldest line from text view
			self.textStorage?.deleteCharacters(in: NSRange(location: 0, length: lastMesage.length))
		}
		// Append new message
		self.textStorage?.append(lineMessage)
		// Scroll to new end
		self.scrollToEndOfDocument(self)
	}

	open override func viewDidEndLiveResize() {
		// Scrolls chat view to have last bottom line visible.
		self.scrollToEndOfDocument(self)
	}

}

/*
 Provides functions related showing/hiding notifications about new messages.
 */
public struct Notifications {

	// Greetings used by notification
	static let GREETINGS: [String] = ["Pst!", "Hola!", "Bok!", "Hallo!", "Saluton!", "Hei!", "Aloha!", "안녕하세요!", "Hai!", "Olá!", "Oi!", "Hallå!", "Hej!", "Chào!", "Hullo!"]

	/*
	 Returns random item from given strings array.
	 */
	static func randomFrom(_ options: [String]) -> String {
		return options[Int(arc4random_uniform(UInt32(options.count)))]
	}

	/*
	 Performs all actions required to show notification about new message.
	 */
	public static func onReceived(_ message: String, window: NSWindow) {
		// Clean up old notificatios
		NSUserNotificationCenter.default.removeAllDeliveredNotifications()

		// Show notification only when related window is not key/active
		if !window.isKeyWindow {
			// Show only new last notification
			let notification = NSUserNotification()
			notification.title = randomFrom(GREETINGS)
			notification.informativeText = "📨"
			notification.soundName = NSUserNotificationDefaultSoundName
			NSUserNotificationCenter.default.deliver(notification)

			// Show badge on dock icon
			NSApplication.shared().dockTile.badgeLabel = "✉️"
			NSApplication.shared().dockTile.display()
			
			// Change window title
			window.title = "kemo✉️rocks"
		}
	}

	public static func hide(_ window: NSWindow) {
		// Clean up old notificatios
		NSUserNotificationCenter.default.removeAllDeliveredNotifications()

		// Hide badge on dock icon
		NSApplication.shared().dockTile.badgeLabel = ""
		NSApplication.shared().dockTile.display()
		
		// Change window title
		window.title = "kemo.rocks"
	}

}
