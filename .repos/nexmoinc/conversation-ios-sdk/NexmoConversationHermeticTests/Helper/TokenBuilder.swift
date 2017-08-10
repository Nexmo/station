//
//  TokenBuilder.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 26/05/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

internal struct TokenBuilder {

    /// HTTP Method
    private enum Method: String {
        case post = "POST"
        case get = "GET"
        case delete = "DELETE"
        case update = "UPDATE"
    }

    private let response: Response?

    private let method: Method?

    // MARK:
    // MARK: Init

    internal init(response: RestResponse?=nil) {
        self.response = response
        self.method = nil
    }

    internal init(response: SocketResponse?=nil) {
        self.response = response
        self.method = nil
    }

    private init(response: Response?, method: TokenBuilder.Method) {
        self.response = response
        self.method = method
    }

    // MARK:
    // MARK: Method

    internal var post: TokenBuilder {
        return TokenBuilder(response: response, method: .post)
    }

    internal var get: TokenBuilder {
        return TokenBuilder(response: response, method: .get)
    }

    internal var delete: TokenBuilder {
        return TokenBuilder(response: response, method: .delete)
    }

    internal var update: TokenBuilder {
        return TokenBuilder(response: response, method: .update)
    }

    // MARK:
    // MARK: Build

    internal var build: String {
        var dict = [String: String]()

        if let response = response {
            dict["malformed_response"] = response.value
        }

        if let method = method {
            dict["request_method"] = method.rawValue
        }

        return dict.JSONString ?? ""
    }
}
