//
//  ChatMessageTextField.swift
//  KemoApp
//
//  Created by Michal Racek on 23/06/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation
import Cocoa

public class ChatMessageTextField: NSTextField {
	
	
	public override func becomeFirstResponder() -> Bool {
		debugPrint("XXX")
		return super.becomeFirstResponder()
	}
	
}
