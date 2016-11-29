//
//  Kemo.swift
//  KemoAll
//
//  Created by Michal Racek on 28/11/16.
//
//

import Cocoa
import Foundation
import KemoApp

open class KemoListView: NSView {
	
	// Size of space between list items
	var spaceSize = 10
	
	// List of views representing lines
	var linesViews : [NSView] = []
	
	override init(frame: CGRect) {
		super.init(frame:frame)
		initUI()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initUI()
	}
	
	open override func awakeFromNib() {
		initUI()
	}
	
	private func initUI(){
		self.wantsLayer = true
		self.layer?.borderColor = NSColor.blue.cgColor
		self.layer?.backgroundColor = NSColor.red.cgColor
		self.layer?.cornerRadius = 3
		self.layer?.borderWidth = 1
		
		
		
		self.addLine(lineView: LineView.message(label: "Test"))
	}
	
	public func addLine(lineView :NSView){
		// Add to views
		self.linesViews.append(lineView)
		// Recompute positions of previous line views and move them up
		debugPrint(lineView.frame.origin.x)
		debugPrint(lineView.frame.origin.y)
		
		// Place new line position
		self.addSubview(lineView, positioned: NSWindowOrderingMode.below, relativeTo: nil)
		// TODO Will be always at bottom
		
	}
	
	func linesHeight()->Int{
		/*
		var height = 0
		for curLine in self.linesViews {
		//height = height + curLine.frame.height + self.spaceSize
		}
		*/
		return 0
	}
	
}

class LineView: NSView {
	
	var myLabel = NSText()
	
	public static func message(label: String)->LineView {
		let view = LineView()
		view.myLabel.string = label
		return view
	}
	
	override init(frame: CGRect) {
		super.init(frame:frame)
		initUI()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initUI()
	}
	
	private func initUI(){
		self.translatesAutoresizingMaskIntoConstraints = true
		self.frame = NSRect(x: 0, y: 0, width: 40, height: 30)
		myLabel.frame = NSRect(x: 0, y: 0, width: 40, height: 30)
		myLabel.backgroundColor = NSColor.green
		
		self.wantsLayer = true
		self.layer?.borderColor = NSColor.blue.cgColor
		self.layer?.backgroundColor = NSColor.red.cgColor
		self.layer?.cornerRadius = 3
		self.layer?.borderWidth = 1
		
		self.addSubview(myLabel)
		
	}
}

