//
//  UIThemeWhite.swift
//  KemoApp
//
//  Created by Michal Racek on 14/07/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation
import Cocoa

/*
 Default white colored theme.
 */
public class UIThemeWhite: UITheme {

	// Basic color types
	let uiColorTypes = UIColorTypes(
		success: NSColor.init(srgbRed: 62.0 / 255.0, green: 169.0 / 255.0, blue: 23.0 / 255.0, alpha: 1.0),
		error: NSColor.red,
		neutral: NSColor.init(srgbRed: 138.0 / 255.0, green: 138.0 / 255.0, blue: 138.0 / 255.0, alpha: 0.3),
		active: NSColor.init(srgbRed: 85.0 / 255.0, green: 86.0 / 255.0, blue: 149.0 / 255.0, alpha: 1.0),
		defaultFont: NSColor.init(srgbRed: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
	)

	// UI component colors
	let uiColorComponents = UIColorComponents(
		bgColor: NSColor.white,
		borderColor: NSColor.init(srgbRed: 138.0 / 255.0, green: 138.0 / 255.0, blue: 138.0 / 255.0, alpha: 0.3),
		readOnlyBorderColor: NSColor.init(srgbRed: 238.0 / 255.0, green: 238.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0),
		importantBorderColor: NSColor.init(srgbRed: 85.0 / 255.0, green: 86.0 / 255.0, blue: 149.0 / 255.0, alpha: 1.0)
	)

	// Messages content colors
	let uiColorContent = UIColorContent(
		receivedTextColor: NSColor.init(srgbRed: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0),
		sentTextColor: NSColor.init(srgbRed: 130.0 / 255.0, green: 130.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0)
	)
	
	// Special messages colors
	let uiColorMessages = UIColorMessages(
		errorBgColor: NSColor.init(srgbRed: 213.0 / 255.0, green: 107.0 / 255.0, blue: 107.0 / 255.0, alpha: 0.9),
		infoBgColor: NSColor.init(srgbRed: 85.0 / 255.0, green: 86.0 / 255.0, blue: 149.0 / 255.0, alpha: 0.9),
		warnBgColor: NSColor.init(srgbRed: 212.0 / 255.0, green: 119.0 / 255.0, blue: 24.0 / 255.0, alpha: 0.9)
	)

}
