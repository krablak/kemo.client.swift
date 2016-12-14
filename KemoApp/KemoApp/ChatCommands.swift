//
//  ChatCommands.swift
//  KemoApp
//
//  Created by Michal Racek on 12/12/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation
import Cocoa

// Result of executed command
public struct CommandResult {
	// Flag says that commands execution should be last.
	let last: Bool
	// Message which is result of command execution.
	let message: String?
}

//
// Chat command behavior
//
public protocol ChatCommand {
	
	// Executes command and returns command result when available
	func run(_ message: String)->CommandResult
	
	// Returns human readable command description
	func description()->String
}

//
// Displays key quality
//
public class KeyQualityChatCommand: ChatCommand {
	
	// Reference to parent view controller which will be affected by command
	let chatViewController: ViewController
	
	let dateFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = DateFormatter.Style.short
		dateFormatter.timeStyle = DateFormatter.Style.medium
		return dateFormatter
	}()
	
	public init(_ chatViewController: ViewController){
		self.chatViewController = chatViewController
	}
	
	public func run(_ message: String)->CommandResult {
		// Secret key guessability score
		let score = KeyUtils.zxcvbn(self.chatViewController.kemoKeyFld.stringValue)
		
		// Display score as message
		if self.chatViewController.state.defaultKeyWarning {
			self.chatViewController.kemoListView.addLine(lineView: KLInfoView.error(" You are using default secret key 😭. Please, change it."))
		}else if score.score < 2 {
			self.chatViewController.kemoListView.addLine(lineView: KLInfoView.warn(score.scoreMessage))
		}else{
			self.chatViewController.kemoListView.addLine(lineView: KLInfoView.light(score.scoreMessage))
		}
		return CommandResult(last: true, message: nil)
	}
	
	public func description()->String{
		return "Displays secret key quality."
	}
}

//
// Clears chat messages.
//
public class ClearChatCommand: ChatCommand {
	
	// Reference to parent view controller which will be affected by command
	let chatViewController: ViewController
	
	public init(_ chatViewController: ViewController){
		self.chatViewController = chatViewController
	}
	
	public func run(_ message: String)->CommandResult {
		self.chatViewController.kemoListView.reset()
		return CommandResult(last: true, message: nil)
	}
	
	public func description()->String{
		return "Clears chat messages."
	}
}

//
// Displays chat session statistics as message
//
public class StatsChatCommand: ChatCommand {
	
	// Reference to parent view controller which will be affected by command
	let chatViewController: ViewController
	
	public init(_ chatViewController: ViewController){
		self.chatViewController = chatViewController
	}
	
	public func run(_ message: String)->CommandResult {
		//let commands = command.onMessage.description.padding(toLength: 30, withPad: " ", startingAt: 0)
		let stateAddon = self.chatViewController.stateAddon
		let stateMsg = " 📊 Current session statistics 📊" + "\n" +
			" State: \(stateAddon.clientState)\n" +
			" Received bytes: \(stateAddon.receivedBytes)\n" +
			" Received messages: \(stateAddon.receivedMessagesCount)\n" +
			" Last received date: \(stateAddon.receivedDate)\n" +
			" Sent bytes: \(stateAddon.sentBytes)\n" +
			" Sent messages: \(stateAddon.sentMessagesCount)\n" +
			" Last sent date: \(stateAddon.sentDate)"
		
		self.chatViewController.kemoListView.addLine(lineView: KLInfoView.light(stateMsg))
		return CommandResult(last: true, message: nil)
	}
	
	public func description()->String{
		return "Displays session statistics."
	}
}

//
// Clears chat messages.
//
public class HelpChatCommand: ChatCommand {
	
	// Reference to parent view controller which will be affected by command
	let chatViewController: ViewController
	
	let commands: ChatCommands
	
	public init(_ chatViewController: ViewController, commands: ChatCommands){
		self.chatViewController = chatViewController
		self.commands = commands
	}
	
	public func run(_ message: String)->CommandResult {
		var helpMessage = " Special commands:"
		for command in self.commands.register {
			let commands = command.onMessage.description.padding(toLength: 30, withPad: ".", startingAt: 0)
			let description = command.command.description().padding(toLength: 40, withPad: " ", startingAt: 0)
			helpMessage = "\(helpMessage)\n \(commands)\(description)"
		}
		self.chatViewController.kemoListView.addLine(lineView: KLInfoView.light(helpMessage))
		return CommandResult(last: true, message: nil)
	}
	
	public func description()->String{
		return "Displays this help message."
	}
}

// Represents result of commads register content execution
public struct ChatCommandsResult {
	// Flag says if any command was executed
	var executed: Bool
	// Result of commands execution if available
	var message: String?
}

//
// Holds and executed commands paired with message matching functions
//
public class ChatCommands {
	
	// Holds command matcher function and reference to related command
	struct RegisteredCommand {
		let onMessage: CommandMatcher
		let command: ChatCommand
	}
	
	// Register of commands
	var register:[RegisteredCommand] = []
	
	
	// Registers new chat command
	public func register(_ onMessage: CommandMatcher, command: ChatCommand){
		self.register.append(RegisteredCommand(onMessage: onMessage, command: command))
	}
	
	// Tries to execute first matching command to given message.
	public func run(_ message: String)->ChatCommandsResult{
		
		// Default result
		var result = ChatCommandsResult(executed: false, message: nil)
		
		// Current version of processed message
		// Can be updated by command
		var curMessage = message
		
		// Search command in register
		for regCmd in self.register {
			// Matching function
			if regCmd.onMessage.matcherFn(message) {
				// Mark result as command executed
				result.executed = true
				// Run command
				let res = regCmd.command.run(curMessage)
				
				// Update processed message by command result
				if let updatedMessage = res.message {
					curMessage = updatedMessage
					result.message = updatedMessage
				}
				
				// Stop commands execution if result is marked as last
				if res.last {
					break
				}
			}
		}
		return result
	}
	
}


//
// Represents function matching message and command.
//
public struct CommandMatcher {
	
	// Matcher function
	let matcherFn: (String)->Bool
	
	// Matcher description
	let description: String
	
}

// Returns function positive in case that any of given string match message
public func matchMessage(_ onMessages:[String])->CommandMatcher {
	return CommandMatcher(
		matcherFn: {message in matchCommand(message: message, onMessages: onMessages)},
		description: toCommandMatcherDesc(onMessages)
	)
}

// Returns true when message matches at least one on message rule
private func matchCommand(message: String, onMessages:[String])->Bool{
	let trimmedMessage = message.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
	for onMsg in onMessages {
		if trimmedMessage == onMsg {
			return true
		}
	}
	return false
}

// Creates human readable list of on messages values delimited with ","
private func toCommandMatcherDesc(_ onMessages:[String])->String{
	var res = ""
	for (i, curMsg) in onMessages.enumerated() {
		if i == 0 {
			res = "\(curMsg)"
		}else{
			res = "\(res), \(curMsg)"
		}
	}
	return res
}
