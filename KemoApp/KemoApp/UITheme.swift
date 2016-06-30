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
 Methods proviging UI components which could be themed.
 */
protocol UIComponents {

	func getMainView() -> NSView

	func getNickFld() -> NSTextField

	func getKeyField() -> NSSecureTextField

	func getMessageTextView() -> NSTextView

	func getMessageField() -> NSTextField

	func getMessageTextScrollView() -> NSScrollView

}

/*
 Defines behavior of theming component for UI look modifications.
 */
protocol UITheme {

	func apply(uiComponents: UIComponents)

	func receiveTextAttrs() -> [String: AnyObject]

	func sentTextAttrs() -> [String: AnyObject]

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

	func apply(uiComponents: UIComponents) {
		// Window style
		uiComponents.getMainView().window?.backgroundColor = bgColor
		uiComponents.getMainView().window?.alphaValue = 1
		
		// Nickname field style
		uiComponents.getNickFld().wantsLayer = true
		uiComponents.getNickFld().layer?.borderColor = fieldLightBorderColor.CGColor
		uiComponents.getNickFld().layer?.backgroundColor = bgColor.CGColor
		uiComponents.getNickFld().layer?.cornerRadius = 3
		uiComponents.getNickFld().layer?.borderWidth = 0
		uiComponents.getNickFld().frame.size.height = 33

		// Key field style
		uiComponents.getKeyField().wantsLayer = true
		uiComponents.getKeyField().layer?.borderColor = fieldLightBorderColor.CGColor
		uiComponents.getKeyField().layer?.backgroundColor = bgColor.CGColor
		uiComponents.getKeyField().layer?.cornerRadius = 3
		uiComponents.getKeyField().layer?.borderWidth = 1
		uiComponents.getKeyField().frame.size.height = 33
		uiComponents.getKeyField().textColor = fontColor

		// Message text view style
		uiComponents.getMessageTextView().wantsLayer = true
		uiComponents.getMessageTextView().layer?.borderColor = NSColor.clearColor().CGColor
		uiComponents.getMessageTextView().layer?.borderWidth = 1
		uiComponents.getMessageTextView().layer?.cornerRadius = 3
		// Style scroll view around message text view component
		uiComponents.getMessageTextScrollView().borderType = NSBorderType.NoBorder
		uiComponents.getMessageTextScrollView().wantsLayer = true
		uiComponents.getMessageTextScrollView().layer?.borderColor = textViewBorderColor.CGColor
		uiComponents.getMessageTextScrollView().layer?.backgroundColor = bgColor.CGColor
		uiComponents.getMessageTextScrollView().layer?.borderWidth = 1
		uiComponents.getMessageTextScrollView().layer?.cornerRadius = 3
		uiComponents.getMessageTextScrollView().layer?.displayIfNeeded()

		// New message field style
		uiComponents.getMessageField().wantsLayer = true
		uiComponents.getMessageField().layer?.borderColor = fieldMessageBorderColor.CGColor
		uiComponents.getMessageField().layer?.backgroundColor = bgColor.CGColor
		uiComponents.getMessageField().layer?.cornerRadius = 3
		uiComponents.getMessageField().layer?.borderWidth = 1
		uiComponents.getMessageField().frame.size.height = 33
		uiComponents.getMessageField().textColor = fontColor
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

