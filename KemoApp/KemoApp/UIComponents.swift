//
//  ChatTextView.swift
//  KemoApp
//
//  Created by Michal Racek on 22/06/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation
import Cocoa

//
// Simple list view representing kemo chat
//
open class KemoListView: NSView {
	
	// View theme instance with default white theme
	open var theme = UIThemeWhite()
	
	// Size of space between list items
	var spaceSize = 2
	
	// Maximal count of lines
	var maxLines = 100
	
	// List of views representing lines
	var linesViews: [NSView] = []
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initUI()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initUI()
	}
	
	private func initUI() {
		self.wantsLayer = true
		self.layer?.borderColor = NSColor.clear.cgColor
		self.layer?.backgroundColor = NSColor.clear.cgColor
		self.layer?.cornerRadius = 0
		self.layer?.borderWidth = 0
	}
	
	// Adds line to chat lines
	public func addLine(lineView: NSView) {
		// Set new line location in view
		lineView.frame.origin.y = 0
		lineView.frame.origin.x = 0
		
		// Update positions of existing lines
		let shiftSize = lineView.frame.height + CGFloat(self.spaceSize)
		self.moveUp(by: shiftSize)
		
		// Add new line view into parent
		self.addSubview(lineView, positioned: NSWindowOrderingMode.below, relativeTo: nil)
		
		// Add to views
		self.linesViews.append(lineView)
		
		// Try remove lines over max lines limit
		tryRemoveMaxLines()
		
		// Update positions of lines
		resizeLines()
		// Update view height
		updateListViewHeight()
		updateListViewWidth()
	}
	
	public func reset() {
		// Remove all displayed messages
		for curLineView in self.linesViews {
			curLineView.removeFromSuperview()
		}
		self.linesViews = []
		// Update to empty height
		updateListViewHeight()
		updateListViewWidth()
	}
	
	open override func setFrameSize(_ newSize: NSSize) {
		if let supView = self.superview {
			// Set parent frame height to computed height
			let superHeight = self.frame.height+60
			let superWidth = self.frame.width+30
			supView.frame = NSRect(x: supView.frame.origin.x, y: supView.frame.origin.x, width: superWidth, height: superHeight)
		}
		super.setFrameSize(newSize)
		
	}
	
	// Resize line heights of all lines
	private func resizeLines() {
		// Variable with current Y position of line
		var curOriginY = CGFloat(4)
		for curLine in self.linesViews.reversed() {
			// Set current position to view
			curLine.frame.origin.y = curOriginY
			// Update position with current view height and space size
			curOriginY = curOriginY + curLine.frame.height + CGFloat(self.spaceSize)
		}
	}
	
	// Whem maximal number of lines is reached remove it
	private func tryRemoveMaxLines() {
		if self.linesViews.count > self.maxLines {
			let removedView = self.linesViews.remove(at: 0)
			removedView.removeFromSuperview()
		}
	}
	
	// Moves existing lines view up
	private func moveUp(by: CGFloat) {
		for curLine in self.linesViews {
			curLine.frame.origin.y = curLine.frame.origin.y + by
		}
	}
	
	// Updates list view height according to displayed lines
	private func updateListViewHeight() {
		if let topLine = self.linesViews.first {
			self.frame = NSRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: topLine.frame.origin.y + topLine.frame.height)
		}
	}
	
	// Updates list view width by line with highes width
	private func updateListViewWidth(){
		var maxWidth = CGFloat(500)
		for curLine in self.linesViews {
			if curLine.frame.width > maxWidth {
				maxWidth = curLine.frame.width
			}
		}
		self.frame = NSRect(x: self.frame.origin.x, y: self.frame.origin.y, width: maxWidth, height: self.frame.height)
	}
	
}

//
// Single line for displaying information and warnings in message list.
//
class KLInfoView: NSView {
	
	enum InfoType {
		case info
		case warn
		case error
		case light
	}
	
	// Inner label view for text
	lazy var label: NSTextField = {
		let lazyLabel = NSTextField()
		lazyLabel.isEditable = false
		return lazyLabel
	}()
	
	// Thin wraper over label whic defines bg anc padding of label
	var labelWrapper = NSView()
	
	// View theme instance with default white theme
	open var theme = UIThemeWhite()
	
	// Type of view information
	var infoType = InfoType.info
	
	// Shortcut for creation info line
	public static func info(_ content: String) -> KLInfoView {
		return KLInfoView().update(content, type: InfoType.info)
	}
	
	// Shortcut for creation error info line
	public static func error(_ content: String) -> KLInfoView {
		return KLInfoView().update(content, type: InfoType.error)
	}
	
	// Shortcut for creation warning info line
	public static func warn(_ content: String) -> KLInfoView {
		return KLInfoView().update(content, type: InfoType.warn)
	}
	
	// Shortcut for creation of light message
	public static func light(_ content: String) -> KLInfoView {
		return KLInfoView().update(content, type: InfoType.light)
	}
	
	@discardableResult public func update(_ content: String, type: InfoType) -> KLInfoView {
		self.label.stringValue = content
		self.infoType = type
		initUI(self.infoType)
		updateSize()
		return self
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initUI(self.infoType)
		updateSize()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initUI(self.infoType)
		updateSize()
	}
	
	func updateSize(){
		self.label.sizeToFit()
		
		self.frame.size = NSSize(width: self.label.frame.size.width+19, height: self.label.frame.size.height+19)
		
		self.labelWrapper.frame.origin = NSPoint(x: 5, y: 0)
		self.labelWrapper.frame.size = NSSize(width: self.label.frame.size.width+8, height: self.label.frame.size.height+19)
		
		self.label.frame.origin = NSPoint(x: 0, y: 9)
		self.label.frame.size = NSSize(width: self.label.frame.size.width, height: self.label.frame.size.height)
	}
	
	func initUI(_ type: InfoType) {
		self.label.font = NSFont.systemFont(ofSize: 13.0, weight: NSFontWeightLight)
		// Label wrapper colors
		self.wantsLayer = true
		self.layer?.backgroundColor = NSColor.clear.cgColor
		self.layer?.borderColor = NSColor.clear.cgColor
		self.layer?.borderWidth = 0
		self.layer?.cornerRadius = 0
		self.layer?.displayIfNeeded()
		
		
		// Label view colors
		var lableBg = theme.uiColorMessages.infoBgColor
		var borderClr = theme.uiColorMessages.infoBgColor
		var fontClr = NSColor.white
		switch type {
		case .error:
			lableBg = NSColor.clear
			fontClr = theme.uiColorMessages.errorBgColor
			borderClr = theme.uiColorMessages.errorBgColor
		case .warn:
			lableBg = NSColor.clear
			fontClr = theme.uiColorMessages.warnBgColor
			borderClr = theme.uiColorMessages.warnBgColor
		case .light:
			lableBg = NSColor.clear
			borderClr = theme.uiColorMessages.infoBgColor
			fontClr = theme.uiColorMessages.infoBgColor
		default:
			lableBg = theme.uiColorMessages.infoBgColor
		}
		
		self.label.backgroundColor = NSColor.clear
		self.label.textColor = fontClr
		self.label.isBordered = false
		self.label.wantsLayer = true
		self.label.layer?.borderColor = NSColor.clear.cgColor
		self.label.layer?.borderWidth = 1
		self.label.layer?.cornerRadius = 3
		self.label.layer?.displayIfNeeded()
		
		
		self.labelWrapper.wantsLayer = true
		self.labelWrapper.layer?.backgroundColor = lableBg.cgColor
		self.labelWrapper.layer?.borderColor = borderClr.cgColor
		self.labelWrapper.layer?.borderWidth = 1
		self.labelWrapper.layer?.cornerRadius = 3
		self.labelWrapper.layer?.displayIfNeeded()
		
		// Compose views hierarchy
		self.addSubview(self.labelWrapper)
		self.labelWrapper.addSubview(self.label)
	}
}

//
// Basic view representing single line within KemoListView
//
class KemoListLineView: NSView {
	
	// View theme instance with default white theme
	open var theme = UIThemeWhite()
	
	// Text content view
	var textView = NSTextView()
	
	
	// Shortcut for creation of line with content
	public static func new(content: String) -> KemoListLineView {
		return KemoListLineView().update(content: content, sent: true)
	}
	
	// Shortcut for creation sent message line
	public static func sent(_ content: String) -> KemoListLineView {
		return KemoListLineView().update(content: content, sent: true)
	}
	
	// Shortcut for creation received message line
	public static func received(_ content: String) -> KemoListLineView {
		return KemoListLineView().update(content: content, sent: false)
	}
	
	// Sets content into line and resize component
	@discardableResult public func update(content: String, sent: Bool) -> KemoListLineView {
		// Prepare new line attributed string (with proper colors etc.)
		let lineAttrs = sent ? UIThemeWhite().sentTextAttrs() : UIThemeWhite().receiveTextAttrs()
		let lineMessage =  NSMutableAttributedString(string: "\(content)", attributes: lineAttrs)
		// Mark links to web in message
		markLinks(lineMessage)
		self.textView.textStorage?.append(lineMessage)
		self.textView.isEditable = false
		
		// Compute lines count
		let linesCount = self.linesCount(str: content)
		// Compute size of text content
		let newSize = self.resize(size: (self.textView.textStorage?.size())!, addHeight: linesCount * 1, addWidth: 15)
		self.textView.frame.size = newSize
		// Compute and set size for line view according to content
		self.frame.size = resize(size: newSize, addHeight: linesCount * 1, addWidth: 15)
		
		// Move text view to top of resized line view
		self.textView.frame.origin.y = self.frame.height - self.textView.frame.height
		
		return self
	}
	
	// Marks links in attributed string
	func markLinks(_ lineMessage: NSMutableAttributedString){
		do {
			let types: NSTextCheckingResult.CheckingType = [.link]
			let detector = try NSDataDetector(types: types.rawValue)
			
			let matches = detector.matches(in: lineMessage.string, options: [], range: NSRange(location: 0, length: lineMessage.string.utf16.count))
			
			let lineMsgStr = (lineMessage.string as NSString)
			for match in matches {
				let url = lineMsgStr.substring(with: match.range)
				lineMessage.addAttribute(NSLinkAttributeName, value: url, range: match.range)
			}
		}catch{
		}
	}
	
	
	// Helper shortcut function for resizing NSSize instances
	private func resize(size: NSSize, addHeight: Int, addWidth: Int) -> NSSize {
		return NSSize(width: size.width + CGFloat(addWidth), height: size.height + CGFloat(addHeight))
	}
	
	// Helper function for counting lines in text content
	private func linesCount(str: String) -> Int {
		return str.characters.filter {
			$0 == "\n"
			}.count
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initUI()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initUI()
	}
	
	func initUI() {
		// Text view is transparent to fit any theme
		self.textView.backgroundColor = NSColor.clear
		
		// Set links color
		self.textView.linkTextAttributes = [NSForegroundColorAttributeName : theme.uiColorContent.linkTextColor, NSUnderlineStyleAttributeName : NSUnderlineStyle.styleNone.rawValue]
		
		// View itself is transparent to fit any theme
		self.wantsLayer = true
		self.layer?.borderColor = NSColor.clear.cgColor
		self.layer?.backgroundColor = NSColor.clear.cgColor
		self.addSubview(textView)
	}
	
}

/*
Provides functions related to selecting random items from set of labels.
*/
public struct RandomLabels {
	
	// Available nicknames
	public static let NICKS: [String] = ["🍑","🦀","🐼","🐍","🐳","💩","🐛","🍌","🍊","🐐","😺","🐶","🐭","🐰","🐻","🐨","🐯","🦁","🐮","🐷","🐸","🐙","🐵","🐔","🐧","🐦","🐢"]
	
	// Greetings used by notification
	static let GREETINGS: [String] = ["Pst!", "Hola!", "Bok!", "Hallo!", "Saluton!", "Hei!", "Aloha!", "안녕하세요!", "Hai!", "Olá!", "Oi!", "Hallå!", "Hej!", "Chào!", "Hullo!"]
	
	/*
	Returns random item from given strings array.
	*/
	public static func randomFrom(_ options: [String]) -> String {
		return options[Int(arc4random_uniform(UInt32(options.count)))]
	}
	
}


/*
Provides functions related showing/hiding notifications about new messages.
*/
public struct Notifications {
	
	/*
	Performs all actions required to show notification about new message.
	*/
	public static func onReceived(_ message: String, window: NSWindow) {
		// Clean up old notificatios
		NSUserNotificationCenter.default.removeAllDeliveredNotifications()
		
		// Show notification only when related window is not key/active
		if !window.isKeyWindow {
			// Show only new last notification
			let notification = NSUserNotification()
			notification.title = RandomLabels.randomFrom(RandomLabels.GREETINGS)
			notification.informativeText = "📨"
			notification.soundName = NSUserNotificationDefaultSoundName
			NSUserNotificationCenter.default.deliver(notification)
			
			// Show badge on dock icon
			NSApplication.shared().dockTile.badgeLabel = "✉️"
			NSApplication.shared().dockTile.display()
			
			// Change window title
			window.title = "kemo✉️rocks"
		}
	}
	
	public static func hide(_ window: NSWindow) {
		// Clean up old notificatios
		NSUserNotificationCenter.default.removeAllDeliveredNotifications()
		
		// Hide badge on dock icon
		NSApplication.shared().dockTile.badgeLabel = ""
		NSApplication.shared().dockTile.display()
		
		// Change window title
		window.title = "kemo.rocks"
	}
	
}
