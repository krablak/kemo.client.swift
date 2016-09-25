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

	public static func toBytes(_ str: String) -> [UInt8] {
		return [UInt8](str.utf8)
	}

	public static func toStr(_ bytes: [UInt8]) -> String {
		return String(bytes: bytes, encoding: String.Encoding.utf8)!
	}
	
	public static func toStrOfChars(_ bytes: [UInt8]) -> String {
		var str = ""
		for curByte in bytes {
			str = str + String(Character(UnicodeScalar(Int(curByte))!))
		}
		return str
	}

	public static func toBytes(_ str: NSString) -> [UInt8] {
		return Conversions.toBytes(String(str))
	}

	public static func toBase64Str(_ bytes: [UInt8]) -> String {
		return Data(bytes: bytes).base64EncodedString(options: [])
	}

	public static func toStrFromBase64(_ base64Str: String) -> String {
		guard let decodedData = Data(base64Encoded: base64Str, options: .ignoreUnknownCharacters) else {
			log.error("Value is not base64 encoded string: '\(base64Str)' ")
			return ""
		}
		return String(data: decodedData, encoding: String.Encoding.utf8)!
	}

	public static func toBytesFromBase64(_ base64Str: String) -> [UInt8] {
		guard let decodedData = Data(base64Encoded: base64Str, options: .ignoreUnknownCharacters) else {
			log.error("Value is not base64 encoded string: '\(base64Str)' ")
			return []
		}
		return toBytes(decodedData);
	}

	static func toBytes(_ nsData: Data) -> [UInt8] {
		var bytes = [UInt8](repeating: 0, count: nsData.count)
		(nsData as NSData).getBytes(&bytes, length: nsData.count)
		return bytes
	}

	public static func toBytesFromHexStr(_ str: String) -> [UInt8] {
		var byteArray = [UInt8]()
		var charsGen = str.characters.makeIterator()
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
	
	public static let SessionKeyAllowedCharacterSet =  CharacterSet(charactersIn:"=\"#%/<>?@\\^`{|}+").inverted

}
