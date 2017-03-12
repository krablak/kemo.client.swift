//
//  KemoPreferencesService.swift
//  KemoApp
//
//  Created by Michal Racek on 12/02/17.
//  Copyright © 2017 PyJunkies. All rights reserved.
//

import Foundation

public class KemoPreferencesService {
	
	struct PrefKeys {
		static let SERVER_URL = "SERVER_URL"
		static let ADD_TIME = "ADD_TIME"
		static let CONN_MESSAGE_ENABLED = "CONN_MESSAGE_ENABLED"
	}
	
	struct PrefDefaults {
		static let SERVER_URL = "wss://kemoundertow-krablak.rhcloud.com:8443/messaging"
		static let ADD_TIME = false
		static let CONN_MESSAGE_ENABLED = false
	}
	
	// Static singleton instance
	public static let service = KemoPreferencesService()
	
	public init() {
		// Perform basic initialization
		checkInitValues()
	}
	
	public func serverUrl() -> String {
		return UserDefaults.standard.string(forKey: PrefKeys.SERVER_URL)!
	}
	
	public func serverUrl(url: String) {
		UserDefaults.standard.set(url, forKey: PrefKeys.SERVER_URL)
	}
	
	public func addTime() -> Bool {
		return UserDefaults.standard.bool(forKey: PrefKeys.ADD_TIME)
	}
	
	public func addTime(state: Int) {
		UserDefaults.standard.set(state == 1 ? true : false, forKey: PrefKeys.ADD_TIME)
	}
	
	public func connMessageEnabled()-> Bool {
		return UserDefaults.standard.bool(forKey: PrefKeys.CONN_MESSAGE_ENABLED)
	}
	
	public func connMessageEnabled(state: Int) {
		UserDefaults.standard.set(state == 1 ? true : false, forKey: PrefKeys.CONN_MESSAGE_ENABLED)
	}

	
	private func checkInitValues() {
		// Set default preferences values when missing
		check(forKey: PrefKeys.SERVER_URL, defaultVal: PrefDefaults.SERVER_URL)
		check(forKey: PrefKeys.ADD_TIME, defaultVal: PrefDefaults.ADD_TIME)
	}
	
	// Checks if preferences item is not missing. And set default value for missing value.
	private func check(forKey: String, defaultVal: String){
		let defaults = UserDefaults.standard
		if defaults.string(forKey: PrefKeys.SERVER_URL) == nil {
			defaults.set(defaultVal, forKey: PrefKeys.SERVER_URL)
		}
	}
	
	// Checks if preferences item is not missing. And set default value for missing value.
	private func check(forKey: String, defaultVal: Bool){
		let defaults = UserDefaults.standard
		if defaults.string(forKey: PrefKeys.SERVER_URL) == nil {
			defaults.set(defaultVal, forKey: PrefKeys.SERVER_URL)
		}
	}
}
