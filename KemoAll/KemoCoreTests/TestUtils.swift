//
//  TestUtils.swift
//  KemoCore
//
//  Created by Michal Racek on 13/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import XCTest
import Foundation
import KemoCore

func generateByteArray(length: Int) -> [UInt8] {
	var genData: [UInt8] = []
	for _ in 0 ... length {
		genData.append(UInt8.init(truncatingBitPattern: arc4random_uniform(255)))
	}
	return genData
}