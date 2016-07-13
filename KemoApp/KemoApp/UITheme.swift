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

	func apply(mainController: ViewController)

	func receiveTextAttrs() -> [String: AnyObject]

	func sentTextAttrs() -> [String: AnyObject]
	
	var uiColorTypes: UIColorTypes { get }

}

/*
 Default white colored theme.
 */
public class UIThemeWhite: UITheme {

	// Components colors
	var bgColor = NSColor.whiteColor()
	var fieldLightBorderColor = NSColor.init(SRGBRed: 138.0 / 255.0, green: 138.0 / 255.0, blue: 138.0 / 255.0, alpha: 0.3)
	var textViewBorderColor = NSColor.init(SRGBRed: 238.0 / 255.0, green: 238.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
	var fieldMessageBorderColor = NSColor.init(SRGBRed: 85.0 / 255.0, green: 86.0 / 255.0, blue: 149.0 / 255.0, alpha: 1.0)
	var fontColor = NSColor.init(SRGBRed: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)

	// Chat text colors
	var receivedTextColor = NSColor.init(SRGBRed: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
	var sentTextColor = NSColor.init(SRGBRed: 130.0 / 255.0, green: 130.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0)

	// Basic color types
	let uiColorTypes = UIColorTypes(
		success: NSColor.greenColor(),
		error: NSColor.redColor(),
		neutral: NSColor.init(SRGBRed: 138.0 / 255.0, green: 138.0 / 255.0, blue: 138.0 / 255.0, alpha: 0.3),
		active: NSColor.init(SRGBRed: 85.0 / 255.0, green: 86.0 / 255.0, blue: 149.0 / 255.0, alpha: 1.0),
		defaultFont: NSColor.init(SRGBRed: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
	)

	func apply(mainController: ViewController) {
		// Window style

		mainController.mainView!.window?.backgroundColor = bgColor
		mainController.mainView!.window?.alphaValue = 1

		// Nickname field style
		mainController.nickFld!.wantsLayer = true
		mainController.nickFld!.layer?.borderColor = fieldLightBorderColor.CGColor
		mainController.nickFld!.layer?.backgroundColor = bgColor.CGColor
		mainController.nickFld!.layer?.cornerRadius = 3
		mainController.nickFld!.layer?.borderWidth = 0
		mainController.nickFld!.frame.size.height = 33

		// Key field style
		mainController.kemoKeyFld!.wantsLayer = true
		mainController.kemoKeyFld!.layer?.borderColor = fieldLightBorderColor.CGColor
		mainController.kemoKeyFld!.layer?.backgroundColor = bgColor.CGColor
		mainController.kemoKeyFld!.layer?.cornerRadius = 3
		mainController.kemoKeyFld!.layer?.borderWidth = 1
		mainController.kemoKeyFld!.frame.size.height = 33
		mainController.kemoKeyFld!.textColor = fontColor

		// Message text view style
		mainController.messageTextView!.wantsLayer = true
		mainController.messageTextView!.layer?.borderColor = NSColor.clearColor().CGColor
		mainController.messageTextView!.layer?.borderWidth = 1
		mainController.messageTextView!.layer?.cornerRadius = 3
		// Style scroll view around message text view component
		mainController.messageTextScrollView!.borderType = NSBorderType.NoBorder
		mainController.messageTextScrollView!.wantsLayer = true
		mainController.messageTextScrollView!.layer?.borderColor = textViewBorderColor.CGColor
		mainController.messageTextScrollView!.layer?.backgroundColor = bgColor.CGColor
		mainController.messageTextScrollView!.layer?.borderWidth = 1
		mainController.messageTextScrollView!.layer?.cornerRadius = 3
		mainController.messageTextScrollView!.layer?.displayIfNeeded()

		// New message field style
		mainController.messageTextFld!.wantsLayer = true
		mainController.messageTextFld!.layer?.borderColor = fieldMessageBorderColor.CGColor
		mainController.messageTextFld!.layer?.backgroundColor = bgColor.CGColor
		mainController.messageTextFld!.layer?.cornerRadius = 3
		mainController.messageTextFld!.layer?.borderWidth = 1
		mainController.messageTextFld!.frame.size.height = 33
		mainController.messageTextFld!.textColor = uiColorTypes.defaultFont

		// Info view button
		mainController.infoBtn!.wantsLayer = true
		mainController.infoBtn!.layer?.backgroundColor = bgColor.CGColor
		mainController.infoBtn!.layer?.displayIfNeeded()
		mainController.infoBtn!.image = NSImage.init(named: "NSStatusAvailable")
		
		//mainController.infoBtn!.color = uiColorTypes.defaultFont

	}

	func receiveTextAttrs() -> [String: AnyObject] {
		return [
			NSFontAttributeName: NSFont.systemFontOfSize(13.0, weight: NSFontWeightLight),
			NSForegroundColorAttributeName: receivedTextColor,
			NSBaselineOffsetAttributeName: 5
		]
	}

	func sentTextAttrs() -> [String: AnyObject] {
		return [
			NSFontAttributeName: NSFont.systemFontOfSize(13.0, weight: NSFontWeightLight),
			NSForegroundColorAttributeName: sentTextColor,
			NSBaselineOffsetAttributeName: 5
		]
	}
}

/*
 UITheme specific color types.
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

