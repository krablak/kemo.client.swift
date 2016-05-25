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
		let rawData: [UInt8] = Array(data[16 ..< data.count])
		// Do decryption
		return try! rawData.decrypt(AES(key: self.key, iv: iv))
	}
}

