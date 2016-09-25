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

open class DefaultEncryption: EncryptionApi {

	open static func encrypt(_ key: [UInt8], keySaltFn: (_ key: [UInt8]) -> [UInt8], data: [UInt8]) -> [UInt8] {
		var decRes: [UInt8] = []
		// Prepare IV 16 bytes long
		let iv = AES.randomIV(AES.blockSize)
		// Salt key
		let saltedKey = keySaltFn(key)
		// Convert key to base64 string bytes
		let keyBase64Bytes = Conversions.toBytes(Conversions.toBase64Str(saltedKey))
		// Prepare cipher
		let cipher = createCipher(key: keyBase64Bytes, iv: iv)
		// Convert data to base64
		let dataBase64Str = Conversions.toBase64Str(data)
		// Convert base64 to bytes
		let dataBase64StryBytes = Conversions.toBytes(dataBase64Str)
		// Encrypt data
		let encrypted = try! dataBase64StryBytes.encrypt(cipher: cipher)
		// Join IV and encrypted data
		decRes = Conversions.toBytes(Conversions.toBase64Str(iv + encrypted))
		return decRes
	}

	open static func decrypt(_ key: [UInt8], keySaltFn: (_ key: [UInt8]) -> [UInt8], data: [UInt8]) -> [UInt8] {
		var decRes: [UInt8] = []
		// Get salted key
		let saltedKey = keySaltFn(key)
		if data.count > 0 && saltedKey.count > 0 {
			// Threat given bytes as base64 encoded string bytes
			let decodedData = Conversions.toBytesFromBase64(Conversions.toStr(data))
			// Get IV
			let iv = Array(decodedData[0 ... 15])
			// Get raw data
			let rawData: [UInt8] = Array(decodedData[16 ..< decodedData.count])
			if rawData.count > 0 {
				// Convert key to base64 string bytes
				let keyBase64Bytes = Conversions.toBytes(Conversions.toBase64Str(saltedKey))
				// Prepare cipher
				let cipher = createCipher(key: keyBase64Bytes, iv: iv)
				// Perform decryption
				let decryptedBytes: [UInt8] = try! cipher.decrypt(rawData)
				// Convert to string - base64 encoded data
				let decryptedBytesAsBase64Sr = Conversions.toStrOfChars(decryptedBytes)
				// To decrypted bytes form from base64
				decRes = Conversions.toBytesFromBase64(decryptedBytesAsBase64Sr)
			}
		}
		return decRes
	}

	/*
	 Unified way of cipher preparation for encryption and decryption.
	 */
	fileprivate static func createCipher(key: [UInt8], iv: [UInt8]) -> AES {
		//public init(key:Array<UInt8>, iv:Array<UInt8>? = nil, blockMode:BlockMode = .CBC, padding: Padding = PKCS7()) throws {
		return try! AES(key: key.sha256(), iv: iv, blockMode: BlockMode.CFB, padding: PKCS7())
	}

	open static func toSessionPath(_ key: [UInt8], saltFn: (_ key: [UInt8]) -> [UInt8]) -> String {
		// Perform basic salting
		let saltedKey = saltFn(key)
		// Convert salted key to base64
		let saltedKeyBase64 = Conversions.toBase64Str(saltedKey)
		// Create hash in hexa string
		let hashStr = saltedKeyBase64.sha256()
		// Convert hash to bytes
		let hash = Conversions.toBytesFromHexStr(hashStr)
		// Convert bytes to base64 string
		let base64Hash = Conversions.toBase64Str(hash)
		// Encode to URL form
		let urlBase64Hash = base64Hash.addingPercentEncoding(withAllowedCharacters: KemoCharacterSets.SessionKeyAllowedCharacterSet)!
		return urlBase64Hash
	}
}

