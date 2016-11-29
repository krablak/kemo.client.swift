//
//  MessagesDataSource.swift
//  KemoAll
//
//  Created by Michal Racek on 14/10/16.
//
//

import Foundation
import Cocoa

public class MessagesDataSource:NSObject, NSTableViewDataSource, NSTableViewDelegate {
	
	public func numberOfRows(in tableView: NSTableView) -> Int {
		debugPrint("AAA")
		//return nameArray.count
		return 2
	}
	
	public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
		return "2"
			//Bundle.main.loadNibNamed("MessageCellView", owner: tableView, topLevelObjects: nil)
	}
	
}
