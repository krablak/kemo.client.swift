//
//  Kemo.swift
//  KemoAll
//
//  Created by Michal Racek on 28/11/16.
//
//

import Cocoa
import Foundation


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
    }
	
	public func reset() {
		// Remove all displayed messages
		for curLineView in self.linesViews {
			curLineView.removeFromSuperview()
		}
		self.linesViews = []
		// Update to empty height
		updateListViewHeight()
	}
	
	open override func setFrameSize(_ newSize: NSSize) {
		if let supView = self.superview {
			// Set parent frame height to computed height
			supView.frame = NSRect(x: supView.frame.origin.x, y: supView.frame.origin.x, width: supView.frame.width, height: self.frame.height)
		}
		super.setFrameSize(newSize)
	}

    // Resize line heights of all lines
    private func resizeLines() {
        // Variable with current Y position of line
        var curOriginY = CGFloat(0)
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
	public func update(content: String, sent: Bool) -> KemoListLineView {
        // Prepare new line attributed string (with proper colors etc.)
		let lineAttrs = sent ? UIThemeWhite().sentTextAttrs() : UIThemeWhite().receiveTextAttrs()
        let lineMessage =  NSMutableAttributedString(string: "\(content)", attributes: lineAttrs)
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
		
		// View itself is transparent to fit any theme
		self.wantsLayer = true
        self.layer?.borderColor = NSColor.clear.cgColor
        self.layer?.backgroundColor = NSColor.clear.cgColor
        self.addSubview(textView)
    }

}


