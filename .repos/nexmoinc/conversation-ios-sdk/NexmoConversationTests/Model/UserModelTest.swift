//
//  UserTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 09/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class UserModelTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("create a user model") {
            let json = self.json(path: .demo1)
            let user = UserModel(json: json)
            
            expect(user).toNot(beNil())
        }
        
        it("manual create a user model") {
            let user = UserModel(displayName: "test", imageUrl: "url", uuid: "uuid", name: "name")
            
            expect(user).toNot(beNil())
            expect(user.displayName) == "test"
            expect(user.imageUrl) == "url"
            expect(user.uuid) == "uuid"
            expect(user.name) == "name"
        }
        
        it("fail creating user model with empty json") {
            let user = UserModel(json: [:])
            
            expect(user).to(beNil())
        }
        
        it("fail creating user model with half empty json") {
            let user = UserModel(json: ["id": ""])
            
            expect(user).to(beNil())
        }
        
        it("creates a fake db user") {
            expect(DBUser(name: "test")).toNot(beNil())
        }
    }
}
