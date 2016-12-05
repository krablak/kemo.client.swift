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
