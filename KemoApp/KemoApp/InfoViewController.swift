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
		dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
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
		self.update(parentControler!.messaging.state)
	}

	public func update(state: MessagingState) {
		self.connStateValueLbl!.stringValue = state.clientState.rawValue
		if state.clientState == .OPEN {
			self.connStateValueLbl!.textColor = self.parentControler?.theme.uiColorTypes.success
			self.parentControler?.infoBtn.image = NSImage.init(named: "NSStatusAvailable")
		} else if state.clientState == .CLOSING || state.clientState == .CLOSED {
			self.connStateValueLbl!.textColor = self.parentControler?.theme.uiColorTypes.error
			self.parentControler?.infoBtn.image = NSImage.init(named: "NSStatusUnavailable")
		} else if state.clientState == .CONNECTING {
			self.connStateValueLbl!.textColor = self.parentControler?.theme.uiColorTypes.active
			self.parentControler?.infoBtn.image = NSImage.init(named: "NSStatusPartiallyAvailable")
		}else {
			self.connStateValueLbl!.textColor = self.parentControler?.theme.uiColorTypes.defaultFont
			self.parentControler?.infoBtn.image = NSImage.init(named: "NSStatusNone")
		}

		self.receivedBytesValueLbl!.stringValue = "\(state.receivedBytes)"
		self.receivedMessagesValueLbl!.stringValue = "\(state.receivedMessagesCount)"
		self.lastReceivedValueLbl!.stringValue = dateFormatter.stringFromDate(state.receivedDate)

		self.sentBytesValueLbl!.stringValue = "\(state.sentBytes)"
		self.sentMessagesValueLbl!.stringValue = "\(state.sentMessagesCount)"
		self.lastSentValueLbl!.stringValue = dateFormatter.stringFromDate(state.sentDate)
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
	popover.behavior = .Semitransient
	popover.appearance = NSAppearance(named: NSAppearanceNameAqua)!

	// Register updates from messaging to controler
	parentControler.messaging.onStateUpdate = infoViewController!.update

	return popover
}