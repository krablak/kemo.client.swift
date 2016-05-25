//
//  EncryptionApi.swift
//  KemoCore
//
//  Created by Michal Racek on 09/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation

/*
 Defines one part of encyrption chain.
 */
public protocol EncryptionPart {

	func encrypt(data: [UInt8]) -> [UInt8]

	func decrypt(data: [UInt8]) -> [UInt8]

}

/*
 Defines component responsible for creating sessing path from key.
 */
public protocol SessionPathProvider {

	func provide(key: [UInt8]) -> String

}

/*
 Defines chain of encryption parts responsible for encryption/decryption.
 */
public class EncryptionChain {

	var encryptionParts: [EncryptionPart] = []

	public init() { }

	public func add(encryptionPart: EncryptionPart) -> EncryptionChain {
		self.encryptionParts.append(encryptionPart)
		return self
	}

	public func encrypt(data: [UInt8]) -> [UInt8] {
		var modifiedData = data
		for curPart in self.encryptionParts {
			modifiedData = curPart.encrypt(modifiedData)
		}
		return modifiedData
	}

	public func decrypt(data: [UInt8]) -> [UInt8] {
		var modifiedData = data
		for i in(0 ... self.encryptionParts.count - 1).reverse() {
			modifiedData = self.encryptionParts[i].decrypt(modifiedData)
		}
		return modifiedData
	}
}

