//
//  NetworkError.swift
//  NexmoConversation
//
//  Created by paul calver on 13/06/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Gloss
import Alamofire

/// Network error protocol
public protocol NetworkErrorProtocol: Error {

    // Error message
    var localizedTitle: String { get }

    // Description of failed request
    var localizedDescription: String { get }

    // Endpoint
    var endpointURL: String? { get }

    // Status code of request
    var code: Int? { get }
}

/// Network error message
public struct NetworkError: NetworkErrorProtocol, Decodable {
    
    // Error message
    public var localizedTitle: String
    
    // Description of failed request
    public var localizedDescription: String
    
    // Endpoint
    public var endpointURL: String?
    
    // Status code of request or Error code from CAPI
    public var code: Int?
    
    // MARK:
    // MARK: Initializers

    /// Method unimplemented
    public init?(json: JSON) {
        // Method unimplemented use other init methods
        return nil
    }

    internal init?(from response: DataResponse<Any>) {
        guard let data = response.data,
        let json = try? JSONSerialization.jsonObject(with: data),
        let parameters = json as? Parameters else {
            return nil
        }

        guard let title: String = "code" <~~ parameters,
            let description: String = "description" <~~ parameters,
            let url = response.response?.url?.absoluteString,
            let statusCode = response.response?.statusCode else { return nil }

        localizedTitle = title
        localizedDescription = description
        endpointURL = url
        code = statusCode
    }

    internal init(localizedTitle: String="", localizedDescription: String="", from response: DefaultDataResponse) {
        self.localizedTitle = localizedTitle.isEmpty ? (response.error?.localizedDescription ?? localizedTitle) : localizedTitle
        self.localizedDescription = localizedDescription
        endpointURL = response.request?.url?.absoluteString
        code = response.response?.statusCode
        
        // if data was passed, try and use it to compose the error title and description
        if let data = response.data,
            let object = try? JSONSerialization.jsonObject(with: data),
            let json = object as? JSON,
            let code: String = "code" <~~ json,
            let description: String = "description" <~~ json {
            self.localizedTitle = code
            self.localizedDescription = description
        }
    }
}
