//
//  EncryptionBasicImpl.swift
//  KemoCore
//
//  Created by Michal Racek on 10/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//
//  Basic implementation of encryption components.
//

import Foundation
import CryptoSwift

public class DefaultEncryption: EncryptionApi {

	public static func encrypt(key: [UInt8], keySaltFn: (key: [UInt8]) -> [UInt8], data: [UInt8]) -> [UInt8] {
		// Prepare IV 16 bytes long
		let iv = AES.randomIV(AES.blockSize)
		// Salt key
		let saltedKey = keySaltFn(key: key)
		// Prepare cipher
		let cipher = createCipher(saltedKey, iv: iv)
		// Encrypt data
		let encrypted = try! data.encrypt(cipher)
		// Join IV and encrypted data
		return iv + encrypted
	}

	public static func decrypt(key: [UInt8], keySaltFn: (key: [UInt8]) -> [UInt8], data: [UInt8]) -> [UInt8] {
		// Get IV
		let iv = Array(data[0 ... 15])
		// Get raw data
		let rawData: [UInt8] = Array(data[16 ..< data.count])
		// Salt key
		let saltedKey = keySaltFn(key: key)
		// Prepare cipher
		let cipher = createCipher(saltedKey, iv: iv)
		// Perform decryption
		let decryptedBytes: [UInt8] = try! cipher.decrypt(rawData)
		return decryptedBytes
	}

	/*
	 Unified way of cipher preparation for encryption and decryption.
	 */
	private static func createCipher(key: [UInt8], iv: [UInt8]) -> AES {
		return try! AES(key: key.sha256(), iv: iv, blockMode: .CFB, padding: PKCS7())
	}

	public static func toSessionPath(key: [UInt8], saltFn: (key: [UInt8]) -> [UInt8]) -> String {
		// Perform basic salting
		let saltedKey = Conversions.toStr(saltFn(key: key))
		// Create hash in hexa string
		let hashStr = saltedKey.sha256()
		// Convert hash to bytes
		let hash = Conversions.toBytesFromHexStr(hashStr)
		// Convert bytes to base64 string
		let base64Hash = Conversions.toBase64Str(hash)
		// Encode to URL form
		let urlBase64Hash = base64Hash.stringByAddingPercentEncodingWithAllowedCharacters(KemoCharacterSets.SessionKeyAllowedCharacterSet)!
		return urlBase64Hash
	}
}

