//
//  PrecentationUtils.swift
//  KemoApp
//
//	Provides various functions for preparing application content for screnshots.
//
//  Created by Michal Racek on 06/07/16.
//  Copyright © 2016 PyJunkies. All rights reserved.
//

import Foundation

public func fillWithConversation(_ viewController: ViewController) {
	// Preview default values
	viewController.kemoKeyFld.stringValue = "some super secret key"
	/*
	viewController.messageTextView.addReceived("[🦀] Hello?")
	viewController.messageTextView.addSent("[🐼] Montag, here.")
	viewController.messageTextView.addReceived("[🦀] Well... What sort were these then, Montag?")
	viewController.messageTextView.addSent("[🐼] I didn't really look, sir. A little bit of everything.")
	viewController.messageTextView.addSent("[🐼] Novels, biographies, adventure stories.")
	viewController.messageTextView.addReceived("[🦀] Oh, routine, eh?")
	viewController.messageTextView.addReceived("[🐼] Why will they do it? It's sheer perversity.")
	viewController.messageTextView.addReceived("[🦀] What does Montag do with his day off duty?")
	viewController.messageTextView.addSent("[🐼] Not very much, sir. Mow the lawn.")
	viewController.messageTextView.addReceived("[🦀] And what if the law forbids that?")
	viewController.messageTextView.addSent("[🐼] Just watch it grow, sir.")
	viewController.messageTextView.addReceived("[🦀] Uh-huh.")
	viewController.messageTextView.addReceived("[🦀] Good.")
	*/
	
	viewController.messageTextFld.stringValue = "Just watch it grow, sir."
}
