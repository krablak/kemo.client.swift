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
	static func encrypt(_ key: [UInt8], keySaltFn: (_ key: [UInt8]) -> [UInt8], data: [UInt8]) -> [UInt8]

	/*
	 Decrypts encrypted data using given key.
	 */
	static func decrypt(_ key: [UInt8], keySaltFn: (_ key: [UInt8]) -> [UInt8], data: [UInt8]) -> [UInt8]

	/*
	 Prepares unique messaging URL path part.
	 */
	static func toSessionPath(_ key: [UInt8], saltFn: (_ key: [UInt8]) -> [UInt8]) -> String
}

