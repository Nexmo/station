//
//  ConversationPreviewModelTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 28/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class ConversationPreviewModelTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("creates an conversation preview model") {
            let mock = SimpleMockDatabase()
            let conversation = mock.conversation1.rest
            let member = conversation.members[0]
            
            expect(ConversationPreviewModel(conversation, for: member)).toNot(beNil())
        }
        
        it("creates a conversation preview with json") {
            let json = self.json(path: .liteConversation)
            let model = ConversationPreviewModel(json: json)
            
            expect(model).toNot(beNil())
            expect(model?.memberId).toNot(beNil())
        }
        
        it("fails to creates a conversation preview with bad name") {
            expect(ConversationPreviewModel(json: ["uuid": ""])).to(beNil())
        }
        
        it("creates a conversation preview with custom data") {
            expect(ConversationPreviewModel(json: [
                "uuid": "1",
                "name": "2",
                "state": "JOINED",
                "member_Id": "mem-123"])
            ).toNot(beNil())
        }
        
        it("fails to create a full conversation without members") {
            let json = self.json(path: .liteConversation)
            let conversation = ConversationModel(json: json)
            
            expect(conversation).to(beNil())
        }
        
        it("fails to create a full conversation with empty members") {
            var json = self.json(path: .liteConversation)
            json["members"] = []
            
            let conversation = ConversationModel(json: json)
            
            expect(conversation).to(beNil())
        }

        it("compares two preview models are same") {
            let json = self.json(path: .liteConversation)
            guard let model = ConversationPreviewModel(json: json) else { return fail() }

            let result = model == model

            expect(result) == true
        }
    }
}
