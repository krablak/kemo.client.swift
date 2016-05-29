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

/*
 Empty encyrption part component. Leaves data unmodified.
 */
public class Dummy: EncryptionPart {

	public init() { }

	public func encrypt(data: [UInt8]) -> [UInt8] {
		return data
	}

	public func decrypt(data: [UInt8]) -> [UInt8] {
		return data
	}
}

/*
 Performs encryption and decryption of raw data like kemo.client.encryption.js implementation.
 */
public class KemoEncryption: EncryptionPart {

	private let key: [UInt8]

	public init(key: [UInt8]) {
		// Create sha256 diggest
		self.key = key.sha256()
	}

	public func encrypt(data: [UInt8]) -> [UInt8] {
		// Prepare IV 16 bytes long
		let iv = AES.randomIV(AES.blockSize)
		// Prepare cipher
		let cipher = createCipher(iv)
		// Encrypt data
		let encrypted = try! data.encrypt(cipher)
		// Join IV and encrypted data
		return iv + encrypted
	}

	public func decrypt(data: [UInt8]) -> [UInt8] {
		// Get IV
		let iv = Array(data[0 ... 15])
		// Get raw data
		let rawData: [UInt8] = Array(data[16 ..< data.count])
		// Prepare cipher
		let cipher = createCipher(iv)
		// Perform decryption
		let decryptedBytes: [UInt8] = try! cipher.decrypt(rawData)
		return decryptedBytes
	}

	/*
	 Unified cipher instance creation.
	 */
	private func createCipher(iv: [UInt8]) -> AES {
		return try! AES(key: self.key, iv: iv, blockMode: .CFB, padding: PKCS7())
	}
}

public class KemoSessionPathProvider: SessionPathProvider {

	public init() {
	}

	public func provide(key: [UInt8]) -> String {
		// Perform basic salting
		let saltedKey = "littlebitof" + Conversions.toStr(key) + "salt"
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

