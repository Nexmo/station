//
//  EventServiceTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 04/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import UIKit
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class EventServiceTest: QuickSpec {
    
    let client = NetworkController(token: "token")
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        
        // MARK:
        // MARK: IPS
        
        it("send a text event") {
            // parameter
            let event = SendEvent(
                conversationId: "CON-0673a8d7-721c-4c68-8374-cbb080065b00",
                from: "MEM-f9b7175c-1ac5-422f-b332-d206974626c4",
                text: "hello from: \(Date())")
            
            // stub
            self.stub(file: .sendImageMessage, request: EventRouter.send(event: event).urlRequest)
            
            // request
            let request = self.client.eventService.send(event: event, success: { _ in
                
            }, failure: { _ in
                fail()
            })
            
            // test
            expect(request.response?.statusCode).toEventually(beGreaterThanOrEqualTo(200))
        }
        
        it("send a failed text event") {
            // parameter
            let event = SendEvent(
                conversationId: "CON-0673a8d7-721c-4c68-8374-cbb080065b00",
                from: "MEM-f9b7175c-1ac5-422f-b332-d206974626c4",
                text: "hello from: \(Date())")
            
            // stub
            self.stubServerError(request: EventRouter.send(event: event).urlRequest)
            
            // request
            let request = self.client.eventService.send(event: event, success: { _ in
                fail()
            }, failure: { _ in
                
            })
            
            // test
            expect(request.response?.statusCode).toEventually(beGreaterThanOrEqualTo(500))
        }
        
        it("send a image event") {
            // parameter
            guard let body = UploadedImage(json: self.json(path: JSONTest.uploadedImage))?.toJSON() else { return fail() }
            
            let event = SendEvent(
                conversationId: "CON-0673a8d7-721c-4c68-8374-cbb080065b00",
                from: "MEM-f9b7175c-1ac5-422f-b332-d206974626c4",
                representations: body
            )
            
            // stub
            self.stub(file: .sendImageMessage, request: EventRouter.send(event: event).urlRequest)
            
            // request
            let request = self.client.eventService.send(event: event, success: { _ in
                
            }, failure: { _ in
                fail()
            })
            
            // test
            expect(request.response?.statusCode).toEventually(beGreaterThanOrEqualTo(200))
        }
        
        it("upload image and then send image payload with the event") {
            self.client.token = "token"
            
            // parameter
            guard let body = UploadedImage(json: self.json(path: JSONTest.uploadedImage))?.toJSON() else { return fail() }
            
            let event = SendEvent(
                conversationId: "CON-0673a8d7-721c-4c68-8374-cbb080065b00",
                from: "MEM-f9b7175c-1ac5-422f-b332-d206974626c4",
                representations: body
            )
            
            guard let image = UIImage(named: AssetsTest.nexmo.path, in: Bundle(for: type(of: self)), compatibleWith: nil) else { return fail() }
            guard let data = UIImageJPEGRepresentation(image, 0.75) else { return fail() }
            
            let parameters: IPSService.UploadImageParameter = (
                image: data,
                size: (originalRatio: nil, mediumRatio: nil, thumbnailRatio: nil)
            )
            
            var id = 0
            
            // stub
            self.stub(file: .uploadedImage, request: IPSRouter.upload().urlRequest)
            self.stub(file: .sendImageMessage, request: EventRouter.send(event: event).urlRequest)
            
            // request
            self.client.eventService.upload(image: parameters, conversationId: event.conversationId, fromId: event.from, success: { response in
                id = response.id
            }, failure: { _ in
                fail()
            })
            
            // test
            expect(id).toEventually(beGreaterThanOrEqualTo(389))
        }
        
        it("upload image and then send a bad image payload with the event") {
            self.client.token = "token"
            
            // parameter
            guard let body = UploadedImage(json: self.json(path: JSONTest.uploadedImage))?.toJSON() else { return fail() }
            
            let event = SendEvent(
                conversationId: "CON-0673a8d7-721c-4c68-8374-cbb080065b00",
                from: "MEM-f9b7175c-1ac5-422f-b332-d206974626c4",
                representations: body
            )
            
            guard let image = UIImage(named: AssetsTest.nexmo.path, in: Bundle(for: type(of: self)), compatibleWith: nil) else { return fail() }
            guard let data = UIImageJPEGRepresentation(image, 0.75) else { return fail() }
            
            let parameters: IPSService.UploadImageParameter = (
                image: data,
                size: (originalRatio: nil, mediumRatio: nil, thumbnailRatio: nil)
            )
            
            var errorResponse: Error?
            
            // stub
            self.stub(json: ["id": "id"], request: IPSRouter.upload().urlRequest)
            self.stub(file: .sendImageMessage, request: EventRouter.send(event: event).urlRequest)
            
            // request
            self.client.eventService.upload(image: parameters, conversationId: event.conversationId, fromId: event.from, success: { _ in
                fail()
            }, failure: { error in
                errorResponse = error
            })
            
            // test
            expect(errorResponse).toEventuallyNot(beNil())
        }
        
        it("upload image and get error 500") {
            self.client.token = "token"
            
            // parameter
            guard let body = UploadedImage(json: self.json(path: JSONTest.uploadedImage))?.toJSON() else { return fail() }
            
            let event = SendEvent(
                conversationId: "CON-0673a8d7-721c-4c68-8374-cbb080065b00",
                from: "MEM-f9b7175c-1ac5-422f-b332-d206974626c4",
                representations: body
            )
            
            guard let image = UIImage(named: AssetsTest.nexmo.path, in: Bundle(for: type(of: self)), compatibleWith: nil) else { return fail() }
            guard let data = UIImageJPEGRepresentation(image, 0.75) else { return fail() }
            
            let parameters: IPSService.UploadImageParameter = (
                image: data,
                size: (originalRatio: nil, mediumRatio: nil, thumbnailRatio: nil)
            )
            
            var errorResponse: Error?
            
            // stub
            self.stubServerError(request: IPSRouter.upload().urlRequest)
            self.stubServerError(request: EventRouter.send(event: event).urlRequest)
            
            // request
            self.client.eventService.upload(image: parameters, conversationId: event.conversationId, fromId: event.from, success: { _ in
                fail()
            }, failure: { error in
                errorResponse = error
            })
            
            // test
            expect(errorResponse).toEventuallyNot(beNil())
        }
    }
}
