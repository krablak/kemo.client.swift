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
		success: NSColor.init(SRGBRed: 62.0 / 255.0, green: 169.0 / 255.0, blue: 23.0 / 255.0, alpha: 1.0),
		error: NSColor.redColor(),
		neutral: NSColor.init(SRGBRed: 138.0 / 255.0, green: 138.0 / 255.0, blue: 138.0 / 255.0, alpha: 0.3),
		active: NSColor.init(SRGBRed: 85.0 / 255.0, green: 86.0 / 255.0, blue: 149.0 / 255.0, alpha: 1.0),
		defaultFont: NSColor.init(SRGBRed: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
	)

	// UI component colors
	let uiColorComponents = UIColorComponents(
		bgColor: NSColor.whiteColor(),
		borderColor: NSColor.init(SRGBRed: 138.0 / 255.0, green: 138.0 / 255.0, blue: 138.0 / 255.0, alpha: 0.3),
		readOnlyBorderColor: NSColor.init(SRGBRed: 238.0 / 255.0, green: 238.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0),
		importantBorderColor: NSColor.init(SRGBRed: 85.0 / 255.0, green: 86.0 / 255.0, blue: 149.0 / 255.0, alpha: 1.0)
	)

	// Messages content colors
	let uiColorContent = UIColorContent(
		receivedTextColor: NSColor.init(SRGBRed: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0),
		sentTextColor: NSColor.init(SRGBRed: 130.0 / 255.0, green: 130.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0)
	)

}