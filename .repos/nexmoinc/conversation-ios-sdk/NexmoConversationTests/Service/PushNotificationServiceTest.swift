//
//  PushNotificationServiceTest.swift
//  NexmoConversation
//
//  Created by shams ahmed on 19/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class PushNotificationServiceTest: QuickSpec {
    
    let client = NetworkController(token: "token")
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        
        // MARK:
        // MARK: Device Token
        
        it("adds device token") {
            guard let token = "fake certificate".data(using: .utf8) else { return fail() }
            
            self.stub(file: .addDeviceToken, request: PushNotificationRouter.updateDevice(id: "token", deviceToken: token).urlRequest)
            
            // request
            let task = self.client.pushNotificationService.update(deviceToken: token, deviceId: "token", success: {
                
                }, failure: { _ in
                    fail()
            })
            
            // test
            expect(task.response?.statusCode).toEventually(equal(200))
        }
        
        it("adds device token with error") {
            guard let token = "bad certificate".data(using: .utf8) else { return fail() }
            
            self.stubServerError(request: PushNotificationRouter.updateDevice(id: "token", deviceToken: token).urlRequest)
            
            var errorResponse: Error?
            
            // request
            let task = self.client.pushNotificationService.update(deviceToken: token, deviceId: "token", success: {
                fail()
            }, failure: { error in
                errorResponse = error
            })
            
            // test
            expect(task.response?.statusCode).toEventually(equal(500))
            expect(errorResponse).toEventuallyNot(beNil())
        }
        
        it("removes device token") {
            self.stubCreated(with: PushNotificationRouter.deleteDeviceToken(id: "token").urlRequest)
            
            // request
            let task = self.client.pushNotificationService.removeDeviceToken(deviceId: "token", success: {
                
                }, failure: { _ in
                    fail()
            })
            
            // test
            expect(task.response?.statusCode).toEventually(equal(201))
        }
        
        it("try to remove device token with error") {
            self.stubServerError(request: PushNotificationRouter.deleteDeviceToken(id: "token").urlRequest)
            
            var errorResponse: Error?
            
            // request
            let task = self.client.pushNotificationService.removeDeviceToken(deviceId: "token", success: {
                fail()
            }, failure: { error in
                errorResponse = error
            })
            
            // test
            expect(task.response?.statusCode).toEventually(equal(500))
            expect(errorResponse).toEventuallyNot(beNil())
        }
        
        // MARK:
        // MARK: Certificate
        
        it("retrieves all certificate") {
            self.stub(file: .uploadPushCertificates, request: PushNotificationRouter.retrieveCertificate(applicationToken: AccountController.applicationId).urlRequest)
            
            var models = [PushNotificationCertificate]()
            
            let task = self.client.pushNotificationService.retrieveCertificate(
                success: { certificates in
                models.append(contentsOf: certificates)
                }, failure: { _ in
                fail()
            })
            
            // test
            expect(task.response?.statusCode).toEventually(equal(200))
            expect(models.count).toEventually(beGreaterThanOrEqualTo(2))
        }

        it("try to retrieves all certificate with bad response type") {
            self.stub(json: [:], request: PushNotificationRouter.retrieveCertificate(applicationToken: AccountController.applicationId).urlRequest)
            
            var errorResponse: Error?
            
            _ = self.client.pushNotificationService.retrieveCertificate(
                success: { _ in
                fail()
            }, failure: { error in
                errorResponse = error
            })
            
            // test
            expect(errorResponse).toEventuallyNot(beNil())
        }
        
        it("try to retrieve all certificate with error") {
            self.stubServerError(request: PushNotificationRouter.retrieveCertificate(applicationToken: AccountController.applicationId).urlRequest)
            
            var errorResponse: Error?
            
            let task = self.client.pushNotificationService.retrieveCertificate(
                success: { _ in
                fail()
            }, failure: { error in
                errorResponse = error
            })
            
            // test
            expect(task.response?.statusCode).toEventually(equal(500))
            expect(errorResponse).toEventuallyNot(beNil())
        }
        
        it("adds a new certificate") {
            let token = "fake_certificate"
            guard let certificate = token.data(using: .utf8) else { return fail() }
            
            self.stub(file: .uploadPushCertificate, request: PushNotificationRouter.upload(certificate: certificate, password: "pass", applicationToken: AccountController.applicationId).urlRequest)
            
            // request
            let task = self.client.pushNotificationService.upload(certificate: certificate, password: nil, success: { _ in
                
                }, failure: { _ in
                    fail()
            })
            
            // test
            expect(task.response?.statusCode).toEventually(equal(200))
        }
        
        it("adds certificate with error") {
            let token = "fake_certificate"
            guard let certificate = token.data(using: .utf8) else { return fail() }
            
            self.stubServerError(request: PushNotificationRouter.upload(certificate: certificate, password: nil, applicationToken: AccountController.applicationId).urlRequest)
            
            var errorResponse: Error?
            
            // request
            let task = self.client.pushNotificationService.upload(certificate: certificate, password: nil, success: { _ in
                fail()
            }, failure: { error in
                errorResponse = error
            })
            
            // test
            expect(task.response?.statusCode).toEventually(equal(500))
            expect(errorResponse).toEventuallyNot(beNil())
        }
        
        it("removes all certificate from capi") {
            self.stubCreated(with: PushNotificationRouter.removeAllCertificate(applicationToken: AccountController.applicationId).urlRequest)
            
            let task = self.client.pushNotificationService.removeAllCertificate(success: {
                
            }, failure: { _ in fail() })
            
            // test
            expect(task.response?.statusCode).toEventually(equal(201))
        }
        
        it("try to removes all certificate with error") {
            self.stubServerError(request: PushNotificationRouter.removeAllCertificate(applicationToken: AccountController.applicationId).urlRequest)
            
            var errorResponse: Error?
            
            let task = self.client.pushNotificationService.removeAllCertificate(success: {
                fail()
            }, failure: { error in
                errorResponse = error
            })
            
            // test
            expect(task.response?.statusCode).toEventually(equal(500))
            expect(errorResponse).toEventuallyNot(beNil())
        }
    }
}
