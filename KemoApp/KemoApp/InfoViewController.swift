//
//  InfoViewController.swift
//  KemoApp
//
//  Provides controllers and components related to displaying information popover.
//
//  Created by Michal Racek on 09/07/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation
import Cocoa
import KemoCore

/*
 Responsible for information view about messaging state and statistics.
 */
public class InfoViewController: NSViewController, NSPopoverDelegate {

	let parentControler: ViewController?

	@IBOutlet weak var connStateValueLbl: NSTextField!

	@IBOutlet weak var receivedBytesValueLbl: NSTextField!

	@IBOutlet weak var receivedMessagesValueLbl: NSTextField!

	@IBOutlet weak var lastReceivedValueLbl: NSTextField!

	@IBOutlet weak var sentMessagesValueLbl: NSTextField!

	@IBOutlet weak var sentBytesValueLbl: NSTextField!

	@IBOutlet weak var lastSentValueLbl: NSTextField!

	let dateFormatter: NSDateFormatter = {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
		dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
		return dateFormatter
	}()

	public init?(parentControler: ViewController) {
		self.parentControler = parentControler
		super.init(nibName: "InfoView", bundle: nil)
	}

	public required init?(coder: NSCoder) {
		self.parentControler = nil
		super.init(coder: coder)
	}

	public override func viewDidAppear() {
		//self.update(KemoClient.ReadyState.CLOSED, newState: parentControler!.stateAddon.clientState)
	}

	public func update(stateAddon: MesssagingStateAddon) {
		// Get current client state
		let newState = stateAddon.clientState
		self.connStateValueLbl!.stringValue = newState.rawValue
		// Display correct state label and icon
		if newState == .OPEN {
			self.connStateValueLbl!.textColor = self.parentControler?.theme.uiColorTypes.success
			self.parentControler?.infoBtn.image = NSImage.init(named: "NSStatusAvailable")
		} else if newState == .CLOSING || newState == .CLOSED {
			self.connStateValueLbl!.textColor = self.parentControler?.theme.uiColorTypes.error
			self.parentControler?.infoBtn.image = NSImage.init(named: "NSStatusUnavailable")
		} else if newState == .CONNECTING {
			self.connStateValueLbl!.textColor = self.parentControler?.theme.uiColorTypes.active
			self.parentControler?.infoBtn.image = NSImage.init(named: "NSStatusPartiallyAvailable")
		} else {
			self.connStateValueLbl!.textColor = self.parentControler?.theme.uiColorTypes.defaultFont
			self.parentControler?.infoBtn.image = NSImage.init(named: "NSStatusNone")
		}

		// Update statics values
		self.receivedBytesValueLbl!.stringValue = "\(stateAddon.receivedBytes)"
		self.receivedMessagesValueLbl!.stringValue = "\(stateAddon.receivedMessagesCount)"
		self.lastReceivedValueLbl!.stringValue = dateFormatter.stringFromDate(stateAddon.receivedDate)

		self.sentBytesValueLbl!.stringValue = "\(stateAddon.sentBytes)"
		self.sentMessagesValueLbl!.stringValue = "\(stateAddon.sentMessagesCount)"
		self.lastSentValueLbl!.stringValue = dateFormatter.stringFromDate(stateAddon.sentDate)
	}

}

/*
 Create new instance of popover with messaging info view.
 */
func infoViewPopover(parentControler: ViewController) -> NSPopover {
	// Init popover and its controller
	let popover = NSPopover()
	let infoViewController = InfoViewController(parentControler: parentControler)
	popover.contentViewController = infoViewController
	popover.delegate = infoViewController

	// Set popover visual style
	popover.behavior = .Transient
	popover.appearance = NSAppearance(named: NSAppearanceNameVibrantLight)!

	// Register updates from messaging to controler
	parentControler.stateAddon.onStateChangeFns.append(infoViewController!.update)

	return popover
}