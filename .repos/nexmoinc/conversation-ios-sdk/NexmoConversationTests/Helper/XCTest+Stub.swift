//
//  XCTest+Stub.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 28/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import XCTest
import Mockingjay
@testable import NexmoConversation

// MARK: - Helper for stubbing json files
internal extension XCTest {
    
    // MARK:
    // MARK: Stub JSON
    
    /// Stub a JSON file
    ///
    /// - parameter file: path of JSON file
    /// - parameter endPoint: endpoint for API
    @discardableResult
    internal func stub(file: JSONTest, request: URLRequest?, statusCode: Int = 200) -> Stub {
        guard let url = request?.url?.absoluteString else { fatalError() }
        guard let path = Bundle(for: type(of: self)).path(forResource: file.rawValue, ofType: "json") else { fatalError() }
        let fileUrl = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: fileUrl) else { fatalError() }
        
        return stub(uri(url), jsonData(data, status: statusCode))
    }
    
    /// Stub a JSON Object
    ///
    /// - parameter json: Dict Object
    /// - parameter endPoint: endpoint for API
    @discardableResult
    internal func stub(json object: [String: Any], request: URLRequest?) -> Stub {
        guard let url = request?.url?.absoluteString else { fatalError() }
        
        return stub(uri(url), Mockingjay.json(object))
    }
    
    // MARK:
    // MARK: Stub 200...300
    
    /// Respond with 201 Created
    ///
    /// - parameter endpoint: endpoint
    @discardableResult
    internal func stubCreated(with request: URLRequest?) -> Stub {
        return stub(request: request, for: 201)
    }
    
    /// Respond with 200 Ok
    ///
    /// - parameter endpoint: endpoint
    @discardableResult
    internal func stubOk(with request: URLRequest?) -> Stub {
        return stub(request: request, for: 200)
    }
    
    // MARK:
    // MARK: Stub 400...600
    
    /// Respond with 406 Client error
    ///
    /// - parameter endpoint: endpoint
    @discardableResult
    internal func stubClientError(request: URLRequest?, with statusCode: Int = 406) -> Stub {
        return stub(request: request, for: statusCode)
    }
    
    /// Respond with 500 Internal Server error
    ///
    /// - parameter endpoint: endpoint
    @discardableResult
    internal func stubServerError(request: URLRequest?, with statusCode: Int = 500) -> Stub {
        return stub(request: request, for: statusCode)
    }
    
    // MARK:
    // MARK: Private - Stub
    
    private func stub(request: URLRequest?, for statusCode: Int) -> Stub {
        guard let url = request?.url?.absoluteString else { fatalError() }
        
        return stub(uri(url), http(statusCode, headers: nil, download: nil))
    }
    
    // MARK:
    // MARK: JSON
    
    /// Convert JSON file in bundle to dictionary object
    ///
    /// - parameter file: path of json
    ///
    /// - returns: dictionary
    internal func json(path: JSONTest) -> [String : Any] {
        guard let path = Bundle(for: type(of: self)).path(forResource: path.rawValue, ofType: "json") else { fatalError() }
        let fileUrl = URL(fileURLWithPath: path)
        
        guard let data = try? Data(contentsOf: fileUrl) else { fatalError() }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let dictionary = json as? [String : Any] else { fatalError() }
        
        return dictionary
    }
}
