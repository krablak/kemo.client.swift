//
//  ViewController.swift
//  Kemo
//
//  Created by Michal Racek on 06/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Cocoa
import KemoCore

open class ViewController: NSViewController, NSWindowDelegate {
	
	// View theme instance
	var theme = UIThemeWhite()
	
	// View state
	var state = ChatViewState()
	
	// Chat commands holders
	var chatCommands = ChatCommands()
	
	@IBOutlet weak var innerScrollView: NSView!
	
	@IBOutlet weak var kemoListView: KemoListView!
	
	@IBOutlet weak var messageTextFld: NSTextField!
	
	@IBOutlet weak var kemoKeyFld: NSSecureTextField!
	
	@IBOutlet weak var nickFld: NSTextField!
	
	@IBOutlet var mainView: NSView!
	
	@IBOutlet weak var kemoListScrollView: NSScrollView!
	
	@IBOutlet weak var infoBtn: NSButton!
	
	@IBOutlet weak var innerView: NSClipView!
	
	// Instance of messaging component
	lazy var messaging: Messaging = {
		let serverUrl = KemoPreferencesService.service.serverUrl()
		log.debug("Using server URL: '\(serverUrl)'")
		// Messaging with empty default key
		var newMessaging = Messaging(url: serverUrl, key: "", onMessage: self.onReceivedMessage)
		// Add messaging state addon to observe
		newMessaging.addons.append(self.stateAddon)
		return newMessaging
	}()
	
	// Messaging state addon
	let stateAddon = MesssagingStateAddon()
	
	// Helper for identification of sent and received messages
	var sentMarker = SentMessageMarker()
	
	// Popover with messaging state/statistics
	var popover: NSPopover!
	
	// Info button click shows/hides popover with messaging state and statistics
	@IBAction func infoBtnClick(_ sender: NSButton) {
		if (popover.isShown) {
			popover.close()
		} else {
			popover.show(relativeTo: NSZeroRect, of: sender, preferredEdge: NSRectEdge.minY)
		}
	}
	
	@IBAction func onKeyChange(_ sender: NSSecureTextField) {
		// Mark key as changed
		self.state.defaultKeyWarning = false
		// Secret key guessability score
		let score = KeyUtils.zxcvbn(sender.stringValue)
		// Only two worst scores are displayed as warning messages
		if score.score <= 2 {
			self.kemoListView.addLine(lineView: KLInfoView.warn(score.scoreMessage))
		}
		
		// Send message
		self.messaging.changeKey(sender.stringValue)
	}
	
	@IBAction func onMessageEnter(_ sender: NSTextField) {
		// Execute commands
		let commandsRes = chatCommands.run(sender.stringValue)
		
		// Send message when no command was executed or commands returns own message version
		if !commandsRes.executed || commandsRes.message != nil {
			// Get message updated by command or value from field
			let commandMessage = commandsRes.message != nil ? commandsRes.message! : sender.stringValue
			
			// Check if default key was changed
			if self.state.defaultKeyWarning {
				// Display error message
				self.kemoListView.addLine(lineView: KLInfoView.error(" Ops! It seems that you are using default key. Be careful!"))
				// Show only first time
				self.state.defaultKeyWarning = false
			}
			
			let message = nickFld.stringValue != "" ? "[\(nickFld.stringValue)] \(commandMessage)" : commandMessage
			// Try to send message
			self.messaging.send(message)
			// Mark message as sent
			sentMarker.markAsSent(message)
			
		}
		// Clean message text field
		sender.stringValue = ""
	}
	
	/*
	Internal method for adding received message into chat view.
	*/
	fileprivate func onReceivedMessage(_ message: String) {
		// dispatch_sync(
		DispatchQueue.main.async {
			// Prepare message for UI according to user preferences
			let uiMessage = KemoPreferencesService.service.addTime() ? addTimeStamp(message) : message
			// Display message according to resolved direction
			if self.sentMarker.isSent(message) {
				self.kemoListView.addLine(lineView: KemoListLineView.sent(uiMessage))
			} else {
				self.kemoListView.addLine(lineView: KemoListLineView.received(uiMessage))
				if self.view.window != nil {
					Notifications.onReceived(message, window: self.view.window!)
				}
			}
		}
	}
	
	override open func viewDidLoad() {
		super.viewDidLoad()
		// Init infoview popover
		self.popover = infoViewPopover(self)
		
		// Init special chat commands
		chatCommands.register(matchMessage(["/s","/stat","/stats"]), command: StatsChatCommand(self))
		chatCommands.register(matchMessage(["/k","/key"]), command: KeyQualityChatCommand(self))
		chatCommands.register(matchMessage(["/c","/clear","/cls","/clr"]), command: ClearChatCommand(self))
		chatCommands.register(matchMessage(["/h","/help"]), command: HelpChatCommand(self, commands: chatCommands))
		
	}
	
	override open func viewDidAppear() {
		super.viewDidAppear()
		
		// Apply theme on current view
		theme.apply(self)
		// Set theme to chat view
		self.kemoListView.theme = theme
		// Reset view content
		self.kemoListView.reset()
		
		// Initial values
		self.view.window?.title = "kemo.rocks"
		self.view.window?.delegate = self
		
		// Set default nick on startup
		nickFld.stringValue = RandomLabels.randomFrom(RandomLabels.NICKS)
		
		// Update info button icon
		self.updateInfoBtn()
		
		// Display welcome message on start
		let welcomeMsg = " Welcome to kemo.rocks OS X app! \n" +
			" 1. 🔑 Choose wisely your secret key \n" +
			" 2. ☎️ Pass secret key to your buddy (by using another communication channel) \n" +
		" 3. 🚀 Set your secret key and start chat"
		self.kemoListView.addLine(lineView: KLInfoView.light(welcomeMsg))
		
		// Check messaging connection on view appearance
		self.messaging.checkConnection()
	}
	
	open override func viewDidDisappear() {
		if self.view.window != nil {
			Notifications.hide(self.view.window!)
		}
	}
	
	// Updates state of info view button
	open func updateInfoBtn(){
		DispatchQueue.main.async {
			if self.stateAddon.clientState == .OPEN {
				self.infoBtn.image = NSImage.init(named: "NSStatusAvailable")
			} else if self.stateAddon.clientState == .CLOSING || self.stateAddon.clientState == .CLOSED {
				self.infoBtn.image = NSImage.init(named: "NSStatusUnavailable")
			} else if self.stateAddon.clientState == .CONNECTING {
				self.infoBtn.image = NSImage.init(named: "NSStatusPartiallyAvailable")
			} else {
				self.infoBtn.image = NSImage.init(named: "NSStatusNone")
			}
		}
	}
	
	/*
	NSWindowDelegate methods.
	*/
	open func windowDidBecomeKey(_ notification: Notification) {
		if self.view.window != nil {
			Notifications.hide(self.view.window!)
		}
	}
}
