//
//  ViewController.swift
//  Kemo
//
//  Created by Michal Racek on 06/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	// MARK: Properties

	@IBOutlet var messageTextView: NSTextView!

	@IBOutlet weak var messageTextFld: NSTextField!

	@IBOutlet weak var kemoKeyFld: NSSecureTextField!

	@IBOutlet var mainView: NSView!

	// MARK: Actions

	/**
	 Called in case when send mesage action is started.

	 - Parameter sender: Text field with message

	 */
	@IBAction func onMessageEnter(sender: NSTextField) {

		debugPrint("" + sender.stringValue)

		// Add entered message into chat view
		addMessageLine(sender.stringValue)

		func updateMessages(messages: [String]) {
			debugPrint(messages)
		}

		// let session = MessagingSession(key: "hovnohovnohovno", serverConfig: ServerConfigs.LOCAL)
		// session.send(sender.stringValue, onReceived: updateMessages)

		// Clean message text field
		sender.stringValue = ""
	}

	private func addMessageLine(message: String) {
		let lineAttrs = [
			NSFontAttributeName: NSFont.systemFontOfSize(13.0, weight: NSFontWeightLight),
			NSForegroundColorAttributeName: NSColor.init(SRGBRed: 130.0 / 255.0, green: 130.0 / 255.0, blue: 139.0 / 255.0, alpha: 1.0),
			NSBaselineOffsetAttributeName: 5
		]
		let attrString = NSMutableAttributedString(string: "\(message)\n", attributes: lineAttrs)
		self.messageTextView.textStorage?.appendAttributedString(attrString)
	}

	private func addSent(message: String) {
		let lineAttrs = [
			NSFontAttributeName: NSFont.systemFontOfSize(13.0, weight: NSFontWeightLight),
			NSForegroundColorAttributeName: NSColor.init(SRGBRed: 130.0 / 255.0, green: 130.0 / 255.0, blue: 139.0 / 255.0, alpha: 1.0),
			NSBaselineOffsetAttributeName: 5
		]
		let attrString = NSMutableAttributedString(string: "\(message)\n", attributes: lineAttrs)
		self.messageTextView.textStorage?.appendAttributedString(attrString)
	}

	private func addReceived(message: String) {
		let lineAttrs = [
			NSFontAttributeName: NSFont.systemFontOfSize(13.0, weight: NSFontWeightLight),
			NSForegroundColorAttributeName: NSColor.init(SRGBRed: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0),
			NSBaselineOffsetAttributeName: 5
		]
		let attrString = NSMutableAttributedString(string: "\(message)\n", attributes: lineAttrs)
		self.messageTextView.textStorage?.appendAttributedString(attrString)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		debugPrint(self)
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		self.view.window?.title = "kemo.rocks"
		self.view.window?.backgroundColor = NSColor.whiteColor()
		self.view.window?.backgroundColor = NSColor.init(SRGBRed: 1, green: 1, blue: 1, alpha: 1)
		// self.view.window?.backgroundColor = NSColor.clearColor()

		// let visualEffectView = NSVisualEffectView(frame: NSMakeRect(0, 0, 300, 180))
		// visualEffectView.blendingMode = NSVisualEffectBlendingMode.BehindWindow
		// visualEffectView.state = NSVisualEffectState.Active

		//self.view.window?.titlebarAppearsTransparent = true

		// let blurryView = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: 100, height: 100))
		// self.mainView.addSubview(aView: NSView)
		// let appearance = NSAppearance(named: NSAppearanceNameVibrantLight)
		// self.view.window!.appearance = appearance

		// this is default value but is here for clarity
		// blurryView.blendingMode = NSVisualEffectBlendingMode.BehindWindow

		// set the background to always be the dark blur
		// blurryView.material = NSVisualEffectMaterial.Dark

		// set it to always be blurry regardless of window state
		// blurryView.state = NSVisualEffectState.Active

		// self.mainView.addSubview(blurryView)
		// self.mainView.wantsLayer = true
		// self.mainView.layer?.backgroundColor = NSColor.init(SRGBRed: 1, green: 1, blue: 1, alpha: 0.1).CGColor

		// self.view.window!.opaque = false
		// self.view.window!.backgroundColor = NSColor.clearColor()
		// self.view.window!.contentView?.addSubview(blurryView)

		// let superView = self.mainView.superview!;

		// superView.wantsLayer = true
		// superView.layer?.backgroundColor = NSColor.init(SRGBRed: 1, green: 1, blue: 0.6, alpha: 0.3).CGColor

		// debugPrint(superView)

		kemoKeyFld.wantsLayer = true
		kemoKeyFld.layer?.borderColor = NSColor.init(SRGBRed: 138.0 / 255.0, green: 138.0 / 255.0, blue: 138.0 / 255.0, alpha: 0.3).CGColor
		kemoKeyFld.layer?.backgroundColor = NSColor.init(SRGBRed: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.5).CGColor
		kemoKeyFld.bezeled = false
		kemoKeyFld.drawsBackground = true
		kemoKeyFld.textColor = NSColor.init(SRGBRed: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
		
		kemoKeyFld.layer?.opaque = false
		kemoKeyFld.layer?.cornerRadius = 3
		kemoKeyFld.layer?.borderWidth = 0
		kemoKeyFld.frame.size.height = 20

		messageTextView.wantsLayer = true;
		messageTextView.layer?.borderColor = NSColor.init(SRGBRed: 238.0 / 255.0, green: 238.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0).CGColor
		messageTextView.layer?.backgroundColor = NSColor.init(SRGBRed: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.5).CGColor
		messageTextView.layer?.borderWidth = 0
		messageTextView.layer?.cornerRadius = 3
		messageTextView.drawsBackground = true

		messageTextFld.wantsLayer = true
		//messageTextFld.layer?.borderColor = NSColor.init(SRGBRed: 0.0, green: 122.0 / 255.0, blue: 1.0, alpha: 0.0).CGColor
		messageTextFld.layer?.borderColor = NSColor.init(SRGBRed: 0.0, green: 122.0 / 255.0, blue: 1.0, alpha: 0.0).CGColor
		messageTextFld.layer?.backgroundColor = NSColor.init(SRGBRed: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.5).CGColor
		messageTextFld.layer?.cornerRadius = 3
		messageTextFld.layer?.borderWidth = 0
		messageTextFld.frame.size.height = 20
		
		messageTextFld.bezeled = false
		messageTextFld.drawsBackground = true
		messageTextFld.textColor = NSColor.init(SRGBRed: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)

		kemoKeyFld.stringValue = "some super secret key"

		addReceived("Hello?")
		addSent("Montag, here.")
		addReceived("Well... What sort were these then, Montag?")
		addSent("I didn't really look, sir. A little bit of everything.")
		addSent("Novels, biographies, adventure stories.")
		addReceived("Oh, routine, eh?")
		addReceived("Why will they do it? It's sheer perversity.")
		addReceived("What does Montag do with his day off duty?")
		addSent("Not very much, sir. Mow the lawn.")
		addReceived("And what if the law forbids that?")
		addSent("Just watch it grow, sir.")
		addReceived("Uh-huh.")
		addReceived("Good.")

		messageTextFld.stringValue = "Just watch it grow, sir."
	}

	override var representedObject: AnyObject? {
		didSet {
			// Update the view, if already loaded.
		}
	}
}
