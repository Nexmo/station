//
//  ConversationTest.swift
//  NexmoConversation
//
//  Created by shams ahmed on 07/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble
import Mockingjay
import RxSwift
import RxCocoa
import RxBlocking
@testable import NexmoConversation

internal class ConversationTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        
        // MARK:
        // MARK: Test
        
        it("compares all error states") {
            expect(Conversation.Errors.cannotProcessRequest) == Conversation.Errors.cannotProcessRequest
            expect(Conversation.Errors.eventBodyIsEmpty) == Conversation.Errors.eventBodyIsEmpty
            expect(Conversation.Errors.memberNotFound) == Conversation.Errors.memberNotFound
        }
        
        it("fails to match error states") {
            expect(Conversation.Errors.cannotProcessRequest) != Conversation.Errors.eventBodyIsEmpty
            expect(Conversation.Errors.eventBodyIsEmpty) != Conversation.Errors.memberNotFound
            expect(Conversation.Errors.memberNotFound) != Conversation.Errors.cannotProcessRequest
        }
        
        it("compares two conversation facade objects") {
            let client = ConversationClient.instance
            
            DatabaseFactory.saveConversation(with: client)
            
            guard let conversation = client.conversation.conversations.first else { return fail() }
            
            let result = conversation == conversation
            
            expect(result) == true
        }
        
        it("fails to compares two conversation facade objects are the same") {
            let client = ConversationClient.instance
            
            _ = SimpleMockDatabase()
            DatabaseFactory.saveConversation(with: client)
            
            let result = client.conversation.conversations.first == client.conversation.conversations[1]
            
            expect(result) == false
        }
    }
}
