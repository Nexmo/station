//
//  Alamofire+DataRequest.swift
//  NexmoConversation
//
//  Created by paul calver on 08/06/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Alamofire

internal extension DataRequest {
    
    // MARK:
    // MARK: Reporting

    /// Report error to manager
    ///
    /// - Parameters:
    ///   - manager: manager
    ///   - statusCodes: statusCodes
    /// - Returns: Self
    @discardableResult
    internal func validateAndReportError(to manager: HTTPSessionManager, statusCodes: [Int]? = nil) -> Self {
        // Validate using the stock validation
        let validateRequest = validate()
        
        // Report any errors
        _ = response { response in
            let successAndRedirectionStatusCodes = Array(200..<300)
            let statusCodes = statusCodes ?? successAndRedirectionStatusCodes

            // stop report when not in range
            guard let statusCode = response.response?.statusCode, !statusCodes.contains(statusCode) else { return }

            manager.errorListener.value = NetworkError(from: response)
        }

        return validateRequest
    }
}
