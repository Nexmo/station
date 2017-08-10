//
//  IPSServiceTest.swift
//  NexmoConversation
//
//  Created by shams ahmed on 29/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import Quick
import Nimble
import Mockingjay
import Alamofire
@testable import NexmoConversation

internal class IPSServiceTest: QuickSpec {
    
    let client = NetworkController(token: "token")
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        
        // MARK:
        // MARK: IPS
        
        it("uploads image to IPS") {
            // stub
            self.stub(file: .uploadedImage, request: IPSRouter.upload().urlRequest)
            
            // parameter
            guard let image = UIImage(named: AssetsTest.nexmo.path, in: Bundle(for: type(of: self)), compatibleWith: nil) else { return fail() }
            guard let data = UIImageJPEGRepresentation(image, 0.75) else { return fail() }
            
            let parameters: IPSService.UploadImageParameter = (
                image: data,
                size: (originalRatio: nil, mediumRatio: nil, thumbnailRatio: nil)
            )
            
            var model: UploadedImage?
            
            // request
            self.client.ipsService.upload(image: parameters, success: { response in
                model = response
                }, failure: { _ in
                    fail()
            })
            
            // test
            expect(model?.id).toEventuallyNot(beNil())
            
            let values: () -> Bool = {
                if let image = model?.image(for: .original),
                    case .link(let id, let url, _, let size) = image {
                    expect(id).toNot(beNil())
                    expect(url.absoluteString).toNot(beEmpty())
                    expect(size) > 1
                    
                    return true
                }
                
                return false
            }
            
            expect(values()).toEventually(beTrue())
        }
        
        it("fails uploading image with client server error") {
            // stub
            self.client.token = "Test Mode"
            
            guard let url1 = URL(string: "\(BaseURL.ips)/v1/image"),
                let url2 = URL(string: "\(BaseURL.ips)/image") else { return fail() }
            
            self.stubClientError(request: URLRequest(url: url1))
            self.stubClientError(request: URLRequest(url: url2))
            
            let parameters: IPSService.UploadImageParameter = (
                image: Data(),
                size: (originalRatio: nil, mediumRatio: nil, thumbnailRatio: nil)
            )
            
            var failed: Bool = false
            let values: () -> Bool = { failed == true }
            
            // request
            self.client.ipsService.upload(image: parameters, success: { _ in
                fail()
            }, failure: { _ in
                failed = true
            })

            expect(values()).toEventually(beTrue(), timeout: 10)
        }
        
        it("should not throw to build a request") {
            let router = IPSRouter.upload()
            let result = try? router.asURLRequest()
            
            expect(result).toNot(beNil())
        }
        
        it("fail appending image to a new event") {
            self.client.token = "token"
            
            // stub
            self.stubServerError(request: IPSRouter.upload().urlRequest)
            
            // parameter
            guard let image = UIImage(named: AssetsTest.nexmo.path, in: Bundle(for: type(of: self)), compatibleWith: nil) else { return fail() }
            guard let data = UIImageJPEGRepresentation(image, 0.75) else { return fail() }
            
            let parameters: IPSService.UploadImageParameter = (
                image: data,
                size: (originalRatio: nil, mediumRatio: nil, thumbnailRatio: nil)
            )
            
            var errorResponse: Error?
            
            // request
            self.client.ipsService.upload(image: parameters, success: { _ in
                fail()
            }, failure: { error in
                errorResponse = error
            })
            
            expect(errorResponse).toEventuallyNot(beNil())
        }
    
        it("fail with bad json response from model response") {
            self.client.token = "token"
            
            // stub
            self.stub(json: [:], request: IPSRouter.upload().urlRequest)
            
            // parameter
            guard let image = UIImage(named: AssetsTest.nexmo.path, in: Bundle(for: type(of: self)), compatibleWith: nil) else { return fail() }
            guard let data = UIImageJPEGRepresentation(image, 0.75) else { return fail() }
            
            let parameters: IPSService.UploadImageParameter = (
                image: data,
                size: (originalRatio: nil, mediumRatio: nil, thumbnailRatio: nil)
            )
            
            var errorResponse: Error?
            
            // request
            self.client.ipsService.upload(image: parameters, success: { _ in
                fail()
            }, failure: { error in
                errorResponse = error
            })
            
            expect(errorResponse).toEventuallyNot(beNil())
        }
    }
}
