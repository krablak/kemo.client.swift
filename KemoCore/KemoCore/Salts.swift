//
//  Salts.swift
//  KemoCore
//
//  Created by Michal Racek on 04/06/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation

/*
 Set of available salts for usable by encryption api.
 */
public struct Salts {

	// Session path salting data
	static let PATH_SALTS = SaltingData(
		noData: "b8af31bea5a94d1582c53cf602bb19ab",
		singlePre: "37bc92fbe3a8425ba0a2902ceb4383aa",
		singlePost: "b7fa709330484789af66bbbaadfddc51",
		defaultPre: "1413ef72661a47c99724d9ec13a80fdf",
		defaultPost: "734cc96c37244fd9a20336509dfd28b4")

	/*
	 Default salting of messaging session path key used across kemo implementation.
	 */
	public static func saltSessionPath(key: [UInt8]) -> [UInt8] {
		return salt(key, saltingData: PATH_SALTS, keyBytesFilterFn: { index, byte in index % 2 == 1 })
	}

	// Session path salting data
	static let ENC_SALTS = SaltingData(
		noData: "e79a713eec5e4d89991c0428efd5704a",
		singlePre: "a36fd8ab8ae04a38b7c04c877c6f39e9",
		singlePost: "b7a9bd24b0314235aeb912c501a829a5",
		defaultPre: "caf8069bd06145e3b926fa23c2fc419e",
		defaultPost: "efbde326ef20437389a65d8f776f32dc")

	/*
	 Default salting of encryption key used across kemo implementation.
	 */
	public static func saltEncKey(key: [UInt8]) -> [UInt8] {
		return salt(key, saltingData: ENC_SALTS, keyBytesFilterFn: { index, byte in index % 2 == 0 })
	}

	// Internal salting function default implementation
	private static func salt(key: [UInt8], saltingData: SaltingData, keyBytesFilterFn: (index: Int, byte: UInt8) -> Bool) -> [UInt8] {
		if key.count == 0 {
			return saltingData.noData
		} else if key.count == 1 {
			// Single byte key is considered as extremely weak
			// User should be informed about that at UI
			log.warning("Single byte key is extremely weak!")
			let base64Bytes = Conversions.toBytes(Conversions.toBase64Str(key))
			return saltingData.singlePre + base64Bytes + saltingData.singlePost
		} else {
			// Covert to base64 and bytes
			let base64Bytes = Conversions.toBytes(Conversions.toBase64Str(key))
			// Get only odd bytes from base64 string bytes
			var keyBytes: [UInt8] = []
			for i in 0...base64Bytes.count - 1 {
				if keyBytesFilterFn(index: i, byte: base64Bytes[i]) {
					keyBytes.append(base64Bytes[i])
				}
			}
			// Append salt bytes to key part
			return saltingData.defaultPre + keyBytes + saltingData.defaultPost
		}
	}
}

/*
 Salting data.
 */
struct SaltingData {

	// Key value used for not key data
	let noData: [UInt8]

	// Key value prefix used for single byte key data
	let singlePre: [UInt8]

	// Key value postfix used for single byte key data
	let singlePost: [UInt8]

	// Default key value prefix
	let defaultPre: [UInt8]

	// Default key value postfix
	let defaultPost: [UInt8]

	init(noData: String, singlePre: String, singlePost: String, defaultPre: String, defaultPost: String) {
		self.noData = Conversions.toBytes(noData)
		self.singlePre = Conversions.toBytes(singlePre)
		self.singlePost = Conversions.toBytes(singlePost)
		self.defaultPre = Conversions.toBytes(defaultPre)
		self.defaultPost = Conversions.toBytes(defaultPost)
	}

}
