//
//  MembershipControllerTest.swift
//  NexmoConversation
//
//  Created by shams ahmed on 29/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
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

internal class MembershipControllerTest: QuickSpec {
    
    lazy var membershipController: MembershipController = {
        let network = NetworkController(token: "token")

        return MembershipController(network: network)
    }()
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        
        // MARK:
        // MARK: Test
        
        it("invites a user to a conversation") {
            self.stub(file: .inviteUser, request: MembershipRouter.invite(id: "test", conversationId: "conversation").urlRequest)
            
            var completed = false
            
            _ = self.membershipController.invite(user: "test", for: "conversation").subscribe(onNext: {
                completed = true
            })
            
            expect(completed).toEventually(beTrue())
        }
        
        it("fails to invites a user to a conversation") {
            self.stubServerError(request: MembershipRouter.invite(id: "test", conversationId: "conversation").urlRequest)
            
            var networkError: Error?
            
            _ = self.membershipController.invite(user: "test", for: "conversation").subscribe(onError: { error in
                networkError = error
            })
            
            expect(networkError).toEventuallyNot(beNil())
        }

        // DISABLED
        it("fetches a member model for a conversation") {
            let model = try? self.membershipController.details(for: "mem-123", in: "con-123")
                .toBlocking()
                .first()
            
            // TODO: #CS-298 wait for response from service team
            expect(model??.id.isEmpty) == false
            expect(model??.userId.isEmpty) == false
        }
        
        it("fails to fetches a member model for a conversation") {
            self.stubServerError(request: MembershipRouter.details(conversationId: "con-123", memberId: "mem-123").urlRequest)
            
            let model = try? self.membershipController.details(for: "mem-123", in: "con-123")
                .toBlocking()
                .first()
            
            expect(model).to(beNil())
        }
        
        it("kicks a member out of a conversation") {
            self.stubOk(with: MembershipRouter.kick(conversationId: "con-123", memberId: "mem-123").urlRequest)
            
            let result = try? self.membershipController.kick("mem-123", in: "con-123")
                .toBlocking()
                .first()
            
            expect(result??.hashValue) == true.hashValue
        }
        
        it("fails to kick out a member for a conversation") {
            self.stubClientError(request: MembershipRouter.kick(conversationId: "con-123", memberId: "mem-123").urlRequest)
            
            let result = try? self.membershipController.kick("mem-123", in: "con-123")
                .toBlocking()
                .first()
            
            expect(result).to(beNil())
        }
    }
}
