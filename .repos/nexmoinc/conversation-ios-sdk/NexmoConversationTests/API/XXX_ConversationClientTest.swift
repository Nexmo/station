//
//  ConversationClientTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 28/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class XXX_ConversationClientTest: QuickSpec {
    
    let client = ConversationClient.instance
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("checks application ID flag check is blank") {
            expect(AccountController.applicationId) == ""
        }
        
        it("login with new user") {
            guard let data = "token".data(using: .utf8) else { return fail() }
            self.client.appLifeCycleController.pushNotificationState = .registeredWithDeviceToken(data)
            
            self.client.login(with: "token")
                .subscribe()
                .addDisposableTo(self.client.disposeBag)
            
            let hasDeviceToken: () -> Bool = {
                if case .registeredWithDeviceToken(_) = self.client.appLifeCycleController.pushNotificationState {
                    return true
                }

                return false
            }
            
            expect(hasDeviceToken()).toEventually(beTrue())
        }

        it("login with new user") {
            guard let data = "token".data(using: .utf8) else { return fail() }
            self.client.appLifeCycleController.pushNotificationState = .registeredWithDeviceToken(data)

            self.client.networkController.socketState.value = .connecting

            self.client.login(with: "token")
                .subscribe()
                .addDisposableTo(self.client.disposeBag)

            let hasDeviceToken: () -> Bool = {
                if case .registeredWithDeviceToken(_) = self.client.appLifeCycleController.pushNotificationState {
                    return true
                }

                return false
            }

            expect(hasDeviceToken()).toEventually(beTrue())
        }

        it("passes a empty device id") {
            self.client.appLifeCycleController.pushNotificationState = .unknown
            
            expect(self.client.deviceToken.isEmpty).to(beTrue())
        }
        
        it("returns 123 device id") {
            guard let data = "123".data(using: .utf8) else { return fail() }
            
            self.client.appLifeCycleController.pushNotificationState = .registeredWithDeviceToken(data)
            
            expect(self.client.deviceToken.isEmpty).toNot(beTrue())
        }
        
        it("adds a new auth token to network layer") {
            let test = "test"
            
            self.client.addAuthorization(with: test)
            
            expect(self.client.networkController.token) == test
        }
        
        it("resets all conversations") {
            self.stubOk(with: MembershipRouter.kick(conversationId: "con-123", memberId: "mem-123").urlRequest)
            
            self.client.leaveAllConversations()
        }

        it("xxx logout current user") {
            self.client.logout()
            UserDefaults.standard.synchronize()
        
            expect(self.client.account.state.value).to(equal(AccountController.State.loggedOut))
        }

        it("compares all states") {
            expect(ConversationClient.State.connected) == ConversationClient.State.connected
            expect(ConversationClient.State.connecting) == ConversationClient.State.connecting
            expect(ConversationClient.State.disconnected) == ConversationClient.State.disconnected
            expect(ConversationClient.State.outOfSync) == ConversationClient.State.outOfSync
            expect(ConversationClient.State.synchronized) == ConversationClient.State.synchronized
            expect(ConversationClient.State.synchronizing(.conversations)) == ConversationClient.State.synchronizing(.conversations)
            expect(ConversationClient.State.synchronizing(.events)) == ConversationClient.State.synchronizing(.events)
            expect(ConversationClient.State.synchronizing(.members)) == ConversationClient.State.synchronizing(.members)
            expect(ConversationClient.State.synchronizing(.users)) == ConversationClient.State.synchronizing(.users)
            expect(ConversationClient.State.synchronizing(.receipts)) == ConversationClient.State.synchronizing(.receipts)
            expect(ConversationClient.State.synchronizing(.tasks)) == ConversationClient.State.synchronizing(.tasks)
        }

        it("fails a state comapare") {
            expect(ConversationClient.State.synchronizing(.users)) != ConversationClient.State.synchronizing(.tasks)
        }

        it("client state string matches") {
            expect(ConversationClient.State.connected.stringValue) == ConversationClient.State.connected.stringValue
            expect(ConversationClient.State.connecting.stringValue) == ConversationClient.State.connecting.stringValue
            expect(ConversationClient.State.disconnected.stringValue) == ConversationClient.State.disconnected.stringValue
            expect(ConversationClient.State.outOfSync.stringValue) == ConversationClient.State.outOfSync.stringValue
            expect(ConversationClient.State.synchronized.stringValue) == ConversationClient.State.synchronized.stringValue
            expect(ConversationClient.State.synchronizing(.conversations).stringValue) == ConversationClient.State.synchronizing(.conversations).stringValue
        }

        it("can update configuration") {
            ConversationClient.configuration = Configuration.default

            expect(ConversationClient.configuration.logLevel.hashValue) == Configuration.LogLevel.warning.hashValue

            ConversationClient.configuration = Configuration(with: Configuration.LogLevel.error)

            expect(ConversationClient.configuration.logLevel.hashValue) == Configuration.LogLevel.error.hashValue
        }

        it("compares error type match up") {
            expect(ConversationClient.Errors.userNotInCorrectState) == ConversationClient.Errors.userNotInCorrectState
            expect(ConversationClient.Errors.networking) == ConversationClient.Errors.networking
            expect(ConversationClient.Errors.busy) == ConversationClient.Errors.busy
            expect(ConversationClient.Errors.unknown("")) == ConversationClient.Errors.unknown("")
        }

        it("compares error type dont match up") {
            expect(ConversationClient.Errors.userNotInCorrectState) != ConversationClient.Errors.unknown("")
            expect(ConversationClient.Errors.networking) != ConversationClient.Errors.unknown("")
            expect(ConversationClient.Errors.busy) != ConversationClient.Errors.unknown("")
            expect(ConversationClient.Errors.unknown("")) != ConversationClient.Errors.busy
        }
    }
}
