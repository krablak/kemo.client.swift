//
//  KeyUtils.swift
//  KemoApp
//
//  Created by Michal Racek on 07/12/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation
import JavaScriptCore
import KemoCore

private var zxcvbnContext: JSContext?

//
// Helper function related to security key
//
public struct KeyUtils {
	
	// Helper function for zxcvbnContext initialization
	private static func getZxcvbnContext()->JSContext? {
		if zxcvbnContext == nil {
			do {
				if let commonJSPath = Bundle.main.path(forResource: "js/zxcvbn", ofType: "js") {
					zxcvbnContext = JSContext()!
					let common = try String(contentsOfFile: commonJSPath, encoding: String.Encoding.utf8)
					zxcvbnContext!.evaluateScript(common)
				}
			} catch (let error) {
				log.error("Error while processing script zxcvbn.js: \(error)")
			}
		}
		return zxcvbnContext
	}
	
	// Returns result of key strength check
	public static func zxcvbn(_ key: String)->ZxcvbnScore{
		if let jsContext = getZxcvbnContext(){
			return ZxcvbnScore(jsContext.evaluateScript("zxcvbn('\(key)')")!)
		}
		return ZxcvbnScore()
	}
}

//
// Simplified "zxcvbn" score result.
//
public class ZxcvbnScore {
	
	// zxcvbn score
	public let score: Int
	
	// Text description of score
	public var scoreMessage = ""
	
	public init(){
		self.score = 5
	}
	
	public init(_ zxcvbnJsVal: JSValue){
		if let valueAsDict = zxcvbnJsVal.toDictionary(){
			self.score = Int(String(describing: valueAsDict["score"]!), radix: 10)!
			// Update text representation of score
			updateScoreMessage(self.score)
		}else{
			self.score = -1
		}
	}
	
	// Updates score text message
	private func updateScoreMessage(_ score: Int){
		switch score {
		case 0:
			self.scoreMessage = " Ops! Your secret key is too guessable."
			break
		case 1:
			self.scoreMessage = " Ops! Your secret key is very guessable."
			break
		case 2:
			self.scoreMessage = " Hmm.. Your secret key is somewhat guessable."
			break
		case 3:
			self.scoreMessage = " Nice. Your secret key is safely unguessable."
			break
		case 4:
			self.scoreMessage = " Wow! Your secret key is very unguessable."
			break
		default:
			self.scoreMessage = ""
		}
	}
	
}

