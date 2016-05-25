//
//  EncryptionParts.swift
//  KemoCore
//
//  Created by Michal Racek on 10/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation
import CryptoSwift

public class Dummy: EncryptionPart {

	public init() { }

	public func encrypt(data: [UInt8]) -> [UInt8] {
		return data
	}

	public func decrypt(data: [UInt8]) -> [UInt8] {
		return data
	}
}

public class SimpleEncryption: EncryptionPart {

	private let key: [UInt8]
	private let iv: [UInt8]

	public init(key: [UInt8]) {
		self.key = asKey32(key)
		// Temporary default IV only for current simple encryption implementation
		self.iv = [134, 163, 112, 234, 34, 12, 9, 54, 64, 246, 221, 32]
	}

	public func encrypt(data: [UInt8]) -> [UInt8] {
		var encryptedRes: [UInt8] = []
		if let encryptor = ChaCha20(key: self.key, iv: self.iv) {
			encryptedRes = try! encryptor.encrypt(data)
		}
		return encryptedRes
	}

	public func decrypt(data: [UInt8]) -> [UInt8] {
		var decryptedRes: [UInt8] = []
		if let encryptor = ChaCha20(key: self.key, iv: self.iv) {
			decryptedRes = try! encryptor.decrypt(data)
		}
		return decryptedRes
	}
}

/*
 Performs encryption and decryption of raw data like kemo.client.encryption.js implementation.
 */
public class KemoEncryption: EncryptionPart {

	private let key: [UInt8]

	public init(key: [UInt8]) {
		// Salt key
		let saltedKey = Conversions.toBytes("clientenc") + key + Conversions.toBytes("salt")
		// Create sha256 diggest
		self.key = saltedKey.sha256()
	}

	public func encrypt(data: [UInt8]) -> [UInt8] {
		// Prepare IV 16 bytes long
		let iv = AES.randomIV(AES.blockSize)
		// Encrypt data
		let encrypted = try! data.encrypt(AES(key: self.key, iv: iv))
		// Join IV and encrypted data
		return iv + encrypted
	}

	public func decrypt(data: [UInt8]) -> [UInt8] {
		// Get IV
		let iv = Array(data[0 ... 15])
		// Get raw data
		let rawData: [UInt8] =  Array(data[16..<data.count])
		// Do decryption
		return try! rawData.decrypt(AES(key: self.key, iv: iv))
	}
}

public class AESEncryption: EncryptionPart {

	private let key: [UInt8]
	private let iv: [UInt8]

	public init(key: [UInt8]) {
		self.key = asKey32(key)
		// Temporary default IV only for current simple encryption implementation
		self.iv = [3, 163, 45, 59, 34, 12, 9, 1, 64, 246, 43, 67, 32, 62, 98, 0]
	}

	public func encrypt(data: [UInt8]) -> [UInt8] {
		return try! data.encrypt(AES(key: self.key, iv: self.iv))
	}

	public func decrypt(data: [UInt8]) -> [UInt8] {
		return try! data.decrypt(AES(key: self.key, iv: self.iv))
	}
}
