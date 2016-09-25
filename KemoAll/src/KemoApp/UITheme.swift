//
//  UITheme.swift
//  KemoApp
//
//  Created by Michal Racek on 18/06/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation
import Cocoa

/*
 Defines behavior of theming component for UI look modifications.
 */
protocol UITheme {

	// Applies color theme on given controller components
	func apply(_ mainController: ViewController)
	// Provides text attributes for received message text
	func receiveTextAttrs() -> [String: AnyObject]

	// Provides text attributes for sent message text
	func sentTextAttrs() -> [String: AnyObject]

	// Set of basic color types
	var uiColorTypes: UIColorTypes { get }

	// Set of UI components color types
	var uiColorComponents: UIColorComponents { get }

	// Set of messages content colors
	var uiColorContent: UIColorContent { get }
}

/*
 UITheme basic color types.
 */
public struct UIColorTypes {
	// Represents succesful operation or state
	let success: NSColor
	// Represents error states
	let error: NSColor
	// Represents neutral states
	let neutral: NSColor
	// Represents active or important states
	let active: NSColor
	// Default font color
	let defaultFont: NSColor
}

/*
 UITheme components colors.
 */
public struct UIColorComponents {
	// Main background color
	let bgColor: NSColor
	// Border color of common fields
	let borderColor: NSColor
	// Border color of read-only fields
	let readOnlyBorderColor: NSColor
	// Border color of important/highlighted fields
	let importantBorderColor: NSColor
}

/*
 UITheme messages content colors.
 */
public struct UIColorContent {
	// Color of received messages font
	let receivedTextColor: NSColor
	// Color of sent messages
	let sentTextColor: NSColor
}

/*
 Extension with default UITheme methods implementations.
 */
extension UITheme {
	func apply(_ mainController: ViewController) {
		mainController.mainView!.window?.backgroundColor = uiColorComponents.bgColor
		mainController.mainView!.window?.alphaValue = 1

		// Nickname field style
		mainController.nickFld!.wantsLayer = true
		mainController.nickFld!.layer?.borderColor = uiColorComponents.borderColor.cgColor
		mainController.nickFld!.layer?.backgroundColor = uiColorComponents.bgColor.cgColor
		mainController.nickFld!.layer?.cornerRadius = 3
		mainController.nickFld!.layer?.borderWidth = 1
		mainController.nickFld!.frame.size.height = 33

		// Key field style
		mainController.kemoKeyFld!.wantsLayer = true
		mainController.kemoKeyFld!.layer?.borderColor = uiColorComponents.borderColor.cgColor
		mainController.kemoKeyFld!.layer?.backgroundColor = uiColorComponents.bgColor.cgColor
		mainController.kemoKeyFld!.layer?.cornerRadius = 3
		mainController.kemoKeyFld!.layer?.borderWidth = 1
		mainController.kemoKeyFld!.frame.size.height = 33
		mainController.kemoKeyFld!.textColor = uiColorTypes.defaultFont

		// Message text view style
		mainController.messageTextView!.wantsLayer = true
		mainController.messageTextView!.layer?.borderColor = NSColor.clear.cgColor
		mainController.messageTextView!.layer?.borderWidth = 1
		mainController.messageTextView!.layer?.cornerRadius = 3
		// Style scroll view around message text view component
		mainController.messageTextScrollView!.borderType = NSBorderType.noBorder
		mainController.messageTextScrollView!.wantsLayer = true
		mainController.messageTextScrollView!.layer?.borderColor = uiColorComponents.readOnlyBorderColor.cgColor
		mainController.messageTextScrollView!.layer?.backgroundColor = uiColorComponents.bgColor.cgColor
		mainController.messageTextScrollView!.layer?.borderWidth = 1
		mainController.messageTextScrollView!.layer?.cornerRadius = 3
		mainController.messageTextScrollView!.layer?.displayIfNeeded()

		// New message field style
		mainController.messageTextFld!.wantsLayer = true
		mainController.messageTextFld!.layer?.borderColor = uiColorComponents.importantBorderColor.cgColor
		mainController.messageTextFld!.layer?.backgroundColor = uiColorComponents.bgColor.cgColor
		mainController.messageTextFld!.layer?.cornerRadius = 3
		mainController.messageTextFld!.layer?.borderWidth = 1
		mainController.messageTextFld!.frame.size.height = 33
		mainController.messageTextFld!.textColor = uiColorTypes.defaultFont

		// Info view button
		mainController.infoBtn!.wantsLayer = true
		mainController.infoBtn!.layer?.backgroundColor = NSColor.clear.cgColor
		mainController.infoBtn!.layer?.displayIfNeeded()
		mainController.infoBtn!.image = NSImage.init(named: "NSStatusAvailable")

	}
	
	func receiveTextAttrs() -> [String: AnyObject] {
		if #available(OSX 10.11, *) {
			return [
				NSFontAttributeName: NSFont.systemFont(ofSize: 13.0, weight: NSFontWeightLight),
				NSForegroundColorAttributeName: uiColorContent.receivedTextColor,
				NSBaselineOffsetAttributeName: 5 as AnyObject
			]
		} else {
			// Fallback on earlier versions
			// TODO
			return [:]
		}
	}

	func sentTextAttrs() -> [String: AnyObject] {
		if #available(OSX 10.11, *) {
			return [
				NSFontAttributeName: NSFont.systemFont(ofSize: 13.0, weight: NSFontWeightLight),
				NSForegroundColorAttributeName: uiColorContent.sentTextColor,
				NSBaselineOffsetAttributeName: 5 as AnyObject
			]
		} else {
			// Fallback on earlier versions
			// TODO
			return [:]
		}
	}
}

