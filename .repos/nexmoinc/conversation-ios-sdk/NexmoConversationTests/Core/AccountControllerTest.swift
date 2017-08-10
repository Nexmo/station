//
//  AccountControllerTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 28/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
import RxSwift
import RxBlocking
@testable import NexmoConversation

internal class AccountControllerTest: QuickSpec {
    
    let mock = SimpleMockDatabase()
    
    let account = AccountController(network: NetworkController(token: "token"))
    
    let databaseManager = DatabaseManager()
    
    let network = NetworkController(token: "token")
    
    lazy var eventController: EventController = { return EventController(network: self.network) }()
    
    lazy var event: EventQueue = {
       return EventQueue(cache: self.cacheManager, event: self.eventController, database: self.databaseManager)
    }()
    
    lazy var cacheManager: CacheManager = {
        let conversationController = ConversationController(network: self.network, account: self.account)
        
        let cache = CacheManager(
            databaseManager: self.databaseManager,
            eventController: EventController(network: self.network),
            account: self.account,
            conversation: conversationController,
            membershipController: MembershipController(network: self.network)
        )
        
        return cache
    }()
    
    // MARK:
    // MARK: Setup
    
    private func setup() {
        cacheManager.eventQueue = event
        account.cacheManager = cacheManager
    }
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        beforeEach {
            self.setup()
        }
        
        // MARK:
        // MARK: Device token
        
        it("update device token") {
            self.cacheManager.eventQueue = self.event
            
            self.stubCreated(with: PushNotificationRouter.updateDevice(id: "id", deviceToken: Data()).urlRequest)
            
            guard let token = "testing...".data(using: .utf8) else { return fail() }
            
            guard let result = try? self.account.update(deviceToken: token, deviceId: "id")
                .toBlocking()
                .first() else { return fail() }
            
            expect(result) == true
        }
        
        it("fails to update device token") {
            self.stubServerError(request: PushNotificationRouter.updateDevice(id: "id", deviceToken: Data()).urlRequest)
            
            guard let token = "testing...".data(using: .utf8) else { return fail() }
            
            var error: Error?
            
            _ = self.account.update(deviceToken: token, deviceId: "id").subscribe(onNext: { _ in
                
            }, onError: { serverError in
                error = serverError
            })
            
            expect(error).toEventuallyNot(beNil())
        }
        
        it("update device token wil nil") {
            guard let token = "testing...".data(using: .utf8) else { return fail() }
            
            guard let result = try? self.account.update(deviceToken: token, deviceId: nil)
                .toBlocking()
                .first() else { return fail() }
            
            expect(result) == false
        }
        
        // MARK:
        // MARK: Login
        
        it("checks user is not loggedin") {
            self.account.state.value = .loggedOut
            
            expect(self.account.state.value == .loggedOut) == true
        }
        
        it("checks user is not loggedin using observable") {
            var newState: AccountController.State?
            
            _ = self.account.state.asObservable().subscribe(onNext: { state in
                newState = state
            })
            
            self.account.state.value = .loggedOut
            
            expect(newState).toEventually(equal(AccountController.State.loggedOut))
        }
        
        it("checks user is loggedin using observable") {
            var newState: AccountController.State?
            
            _ = self.account.state.asObservable().subscribe(onNext: { state in
                newState = state
            })
            
            let session = Session(id: "1", userId: "usr-123", name: "user 1")
            
            self.account.state.value = .loggedIn(session)
            
            expect(newState).toEventually(equal(AccountController.State.loggedIn(session)))
        }
        
        // MARK:
        // MARK: Token
        
        it("makes request to remove device token from account") {
            self.stubCreated(with: PushNotificationRouter.deleteDeviceToken(id: "token").urlRequest)
            
            expect(self.account.removeDeviceToken(id: "token")) == true
        }
        
        // MARK:
        // MARK: User
        
        it("fetches user model") {
            self.stub(file: .demo1, request: AccountRouter.user(id: "usr-123").urlRequest)
            
            guard let user = try? self.account.user(with: "usr-123").toBlocking().first() else { return fail() }
        
            expect(user?.uuid).toNot(beNil())
            expect(user?.displayName.isEmpty) == false
        }
        
        it("fails to fetch a specfic user model") {
            self.stubServerError(request: AccountRouter.user(id: "usr-123").urlRequest)
            
            let user = try? self.account.user(with: "usr-123")
                .toBlocking()
                .first()
            
            expect(user).to(beNil())
        }
        
        it("updates the keychain with new token") {
            self.account.token = "token-123"
            
            expect(self.account.token) == "token-123"
        }

        it("remove the token keychain with nil") {
            self.account.token = nil
            
            expect(self.account.token).to(beNil())
        }
        
        it("valdiates equal for state match up") {
            let session = Session(id: "1", userId: "usr-123", name: "test")
            
            expect(AccountController.State.loggedOut) == AccountController.State.loggedOut
            expect(AccountController.State.loggedIn(session)) == AccountController.State.loggedIn(session)
            expect(AccountController.State.loggedIn(session)) != AccountController.State.loggedOut
        }
        
        it("fetches the current user") {
            expect { try self.databaseManager.user.insert(self.mock.user1) }.toNot(throwAssertion())
            
            self.account.userId = self.mock.user1.rest.uuid
            
            expect(self.account.user).toNot(beNil())
        }
        
        it("fails to fetch the current user") {
            self.account.userId = ""
            self.account.state.value = .loggedOut
            
            expect(self.account.user).to(beNil())
        }
    }
}
