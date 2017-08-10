//
//  RequestRetry.swift
//  NexmoConversation
//
//  Created by shams ahmed on 19/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Alamofire

/// HTTP Status Cdoe
private enum StatusCode: Int {
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case payloadTooLarge = 413
    case requestURITooLong = 414
    case unsupportedMediaType = 415
    case requestedRangeNotSatisfiable = 416
    case expectationFailed = 417
    case imATeapot = 418
    case misdirectedRequest = 421
    case unprocessableEntity = 422
    case locked = 423
    case failedDependency = 424
    case upgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequests = 429
    case requestHeaderFieldsTooLarge = 431
    case connectionClosedWithoutResponse = 444
    case unavailableForLegalReasons = 451
    case clientClosedRequest = 499
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case HTTPVersionNotSupported = 505
    case variantAlsoNegotiates = 506
    case insufficientStorage = 507
    case loopDetected = 508
    case notExtended = 510
    case networkAuthenticationRequired = 511
    case networkConnectTimeoutError = 599
}

/// Vaild retry network request
internal struct RequestRetry: RequestRetrier {
    
    // MARK:
    // MARK: RequestRetrier
    
    internal func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        // max 3 attempts
        guard request.retryCount <= 3 else {
            return completion(false, 0.0)
        }
        
        let unacceptableStatusCode: [StatusCode] = [.badRequest, .unauthorized, .forbidden, .notFound, .methodNotAllowed, .notAcceptable, .tooManyRequests] // timeout
        
        // avoid retry for status codes...
        guard let code = request.response?.statusCode,
            let statusCode = StatusCode(rawValue: code),
            !unacceptableStatusCode.contains(statusCode) else {
            return completion(false, 0.0)
        }
    
        completion(true, 0.0)
    }
}
