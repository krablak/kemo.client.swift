//
//  EncryptionUtils.swift
//  KemoCore
//
//  Created by Michal Racek on 13/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation

public func naiveEncChain(key: [UInt8]) -> EncryptionChain {
	let chain = EncryptionChain()
	chain.add(SimpleEncryption(key: key))
	chain.add(AESEncryption(key: key))
	return chain
}

public func asKey32(key: [UInt8]) -> [UInt8] {
	return key.sha256()
}

// Provides basic coverstion functions
public struct Conversions {

	public static func toBytes(str: String) -> [UInt8] {
		var byteArray = [UInt8]()
		for char in str.utf8 {
			byteArray += [char]
		}
		return byteArray
	}

	public static func toStr(bytes: [UInt8]) -> String {
		var str = ""
		for curByte in bytes {
			str = str + String(Character(UnicodeScalar(Int(curByte))))
		}
		return str
	}

	public static func toBytes(str: NSString) -> [UInt8] {
		return Conversions.toBytes(String(str))
	}

	public static func toBase64Str(bytes: [UInt8]) -> String {
		return NSData(bytes: bytes).base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
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
	
	static func toBytes(nsData: NSData)->[UInt8]{
		var bytes = [UInt8](count: nsData.length, repeatedValue: 0)
		nsData.getBytes(&bytes, length: nsData.length)
		return bytes
	}
}
