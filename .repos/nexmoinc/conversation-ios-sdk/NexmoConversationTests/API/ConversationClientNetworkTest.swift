//
//  ConversationClientTest+Network.swift
//  NexmoConversation
//
//  Created by shams ahmed on 13/06/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
import RxSwift
import RxTest
import RxBlocking

@testable import NexmoConversation

internal class ConversationClientNetworkTest: QuickSpec {
    
    let client = ConversationClient.instance
    
    lazy var conversation: ConversationController = {
        ConversationClient.instance.account.state.value = .loggedIn(Session(id: "s-123", userId: "usr-123", name: "name"))
        
        return ConversationClient.instance.conversation
    }()
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        beforeSuite {
            self.client.addAuthorization(with: "token")
        }

        it("reports an error for 300 status code") {
            self.stub(file: .errorNotFound, request: ConversationRouter.all().urlRequest, statusCode: 300)
            self.client.addAuthorization(with: "token")
            
            _ = self.client.conversation.all().subscribe()
            
            do {
                let error = try self.client.unhandledError.toBlocking().first()
                
                expect(error?.code) == 300
                expect(error?.localizedDescription) == "some description"
                expect(error?.endpointURL?.characters.count).to(beGreaterThan(5))
            } catch let error {
                fail(error.localizedDescription)
            }
        }
        
        it("reports an error for 400 client side status code") {
            self.stub(file: .errorNotFound, request: ConversationRouter.all().urlRequest, statusCode: 400)
            
            _ = self.client.conversation.all().subscribe()
            
            do {
                let error = try self.client.unhandledError.toBlocking().first()
                
                expect(error?.code) == 400
                expect(error?.localizedDescription) == "some description"
                expect(error?.endpointURL?.characters.count).to(beGreaterThan(5))
            } catch let error {
                fail(error.localizedDescription)
            }
        }
        
        it("reports an error for 500 server side status code") {
            self.stubServerError(request: ConversationRouter.all().urlRequest)
            
            _ = self.client.conversation.all().subscribe()
            
            do {
                let error = try self.client.unhandledError.toBlocking().first()
                
                expect(error?.code) == 500
                expect(error?.localizedTitle) == "Response status code was unacceptable: 500."
            } catch let error {
                fail(error.localizedDescription)
            }
        }
        
        it("doesn't report an error for 200 status code and json data is parsed") {
            self.stub(file: .conversations, request: ConversationRouter.all().urlRequest)
            
            if let request: [ConversationPreviewModel]? = try? self.conversation.all().toBlocking().first() {
                expect(request?.isEmpty) == false
            } else {
                fail()
            }
        }
    }
}
