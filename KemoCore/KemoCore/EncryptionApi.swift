//
//  EncryptionApi.swift
//  KemoCore
//
//  Created by Michal Racek on 09/02/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation

/*
 Defines basic functions required for secured data transmission.
 */
public protocol EncryptionApi {

	/*
	 Encrypts data using given key.
	 */
	static func encrypt(key: [UInt8], data: [UInt8]) -> [UInt8]

	/*
	 Decrypts encrypted data using given key.
	 */
	static func decrypt(key: [UInt8], data: [UInt8]) -> [UInt8]

	/*
	 Prepares unique messaging URL path part.
	 */
	static func toSessionPath(key: [UInt8]) -> String
}

