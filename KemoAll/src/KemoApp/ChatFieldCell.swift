//
//  ChatFieldCell.swift
//  KemoAll
//
//  Created by Michal Racek on 01/11/16.
//
//

import Foundation
import Cocoa


class ChatFieldCell : NSTextFieldCell {
	
}

class ChatLineCell : NSView {
	
	@IBOutlet weak var textLabel: NSTextField!
	
	override init(frame: CGRect) { // for using CustomView in code
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
		super.init(coder: aDecoder)
	}
	
	override func awakeFromNib() {
		debugPrint("A")
	}
	
}

public class CustomView: NSView {
	
	var myLabel = NSText()
	
	public static func message(label: String)->CustomView {
		let view = CustomView()
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
	
	
	/*
	override func setFrameSize(_ newSize: NSSize) {
		super.setFrameSize(NSSize(width: 40, height: 20))
		debugPrint("newSize: \(newSize)")
		
	}
	*/

	
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
		
		
		
		//self.topAnchor.constraint(equalTo: NSLayoutAnchor., constant: <#T##CGFloat#>)
		
		/*
		let views = ["iconImageView": self]
		var allConstraints = [NSLayoutConstraint]()
		let iconVerticalConstraints = NSLayoutConstraint.constraints(
			withVisualFormat: "V:[iconImageView(30)]",
			options: [NSLayoutFormatOptions.alignAllLeading, NSLayoutFormatOptions.alignAllTrailing],
			metrics: nil,
			views: views)
		allConstraints += iconVerticalConstraints
		NSLayoutConstraint.activate(allConstraints)
		*/
		
		//self.addConstraint(constrTop)
		//self.addConstraint(constrBtm)
	}
}

enum CellViewError: Error {
	case noViewFound
	case noNibFound
}

public func loadCellView() throws -> NSView{
	var loadedViews:NSArray = []
	
	if Bundle.main.loadNibNamed("MessageCellView", owner: nil, topLevelObjects: &loadedViews) {
		for item in loadedViews {
			if let cellView = item as? ChatLineCell {
				return cellView
			}else{
				throw CellViewError.noViewFound
			}
		}
		throw CellViewError.noViewFound
	}else{
		throw CellViewError.noNibFound
	}
}
