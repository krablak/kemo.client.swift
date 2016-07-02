//
//  EncryptionUtils.swift
//  KemoCore
//
//  Created by Michal Racek on 13/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation
import CryptoSwift

// Provides basic coversion functions
public struct Conversions {

	public static func toBytes(str: String) -> [UInt8] {
		return [UInt8](str.utf8)
	}

	public static func toStr(bytes: [UInt8]) -> String {
		return String(bytes: bytes, encoding: NSUTF8StringEncoding)!
	}

	public static func toBytes(str: NSString) -> [UInt8] {
		return Conversions.toBytes(String(str))
	}

	public static func toBase64Str(bytes: [UInt8]) -> String {
		return NSData(bytes: bytes).base64EncodedStringWithOptions([])
	}

	public static func toStrFromBase64(base64Str: String) -> String {
		guard let decodedData = NSData(base64EncodedString: base64Str, options: .IgnoreUnknownCharacters) else {
			log.error("Value is not base64 encoded string: '\(base64Str)' ")
			return ""
		}
		return String(data: decodedData, encoding: NSUTF8StringEncoding)!
	}

	public static func toBytesFromBase64(base64Str: String) -> [UInt8] {
		guard let decodedData = NSData(base64EncodedString: base64Str, options: .IgnoreUnknownCharacters) else {
			log.error("Value is not base64 encoded string: '\(base64Str)' ")
			return []
		}
		return toBytes(decodedData);
	}

	static func toBytes(nsData: NSData) -> [UInt8] {
		var bytes = [UInt8](count: nsData.length, repeatedValue: 0)
		nsData.getBytes(&bytes, length: nsData.length)
		return bytes
	}

	public static func toBytesFromHexStr(str: String) -> [UInt8] {
		var byteArray = [UInt8]()
		var charsGen = str.characters.generate()
		while let firstChar = charsGen.next() {
			if let nextChar = charsGen.next() {
				if let num = UInt8("\(firstChar)\(nextChar)", radix: 16) {
					byteArray.append(num)
				}
			}
		}
		return byteArray
	}
}

public struct KemoCharacterSets{
	
	public static let SessionKeyAllowedCharacterSet =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|}+").invertedSet

}
