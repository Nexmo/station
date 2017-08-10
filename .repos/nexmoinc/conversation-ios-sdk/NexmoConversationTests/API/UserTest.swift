//
//  UserTest.swift
//  NexmoConversation
//
//  Created by shams ahmed on 05/07/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble
import Mockingjay
import RxSwift
import RxTest
import RxBlocking
@testable import NexmoConversation

internal class UserTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        
        // MARK:
        // MARK: Test
        
        it("creates a user model from db") {
            ConversationClient.instance.account.state.value = .loggedIn(Session(id: "usr-1", userId: "usr-1", name: "usr-1"))
            
            let user = User(data: SimpleMockDatabase().user1)
            
            expect(user.displayName.isEmpty) == false
            expect(user.hashValue) > 1
            expect(user.description.isEmpty) == false
            expect(user.name.isEmpty) == false
            expect(user.uuid.isEmpty) == false
            expect(user.isMe) == true
            
            ConversationClient.instance.account.state.value = .loggedOut
        }

        it("compares two states equal") {
            let user1 = User(data: SimpleMockDatabase().user1)
            let user2 = User(data: SimpleMockDatabase().user1)
            
            let result1 = user1 == user2
            let result2 = user1.isEqual(user2)
            
            expect(result1) == true
            expect(result2) == true
        }
        
        it("fails to match two states") {
            let user1 = User(data: SimpleMockDatabase().user1)
            let user2 = User(data: SimpleMockDatabase().user2)
            
            let result1 = user1 == user2
            let result2 = user1.isEqual(user2)
            let result3 = user1.isEqual("usr-3")
            
            expect(result1) == false
            expect(result2) == false
            expect(result3) == false
        }
    }
}
