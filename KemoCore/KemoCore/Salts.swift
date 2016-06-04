//
//  Salts.swift
//  KemoCore
//
//  Created by Michal Racek on 04/06/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation

/*
 Set of available salts for usable by encryption api.
 */
public struct Salts {

	/*
	 Default salting of encryption key used across kemo implementation.
	 */
	public static func saltEncKey(key: [UInt8]) -> [UInt8] {
		return Conversions.toBytes("clientenc") + key + Conversions.toBytes("salt")
	}

	/*
	 Default salting of messaging session path key used across kemo implementation.
	 */
	public static func saltSessionPath(key: [UInt8]) -> [UInt8] {
		return Conversions.toBytes("littlebitof") + key + Conversions.toBytes("salt")
	}

}