//
//  PushNotificationRouter.swift
//  NexmoConversation
//
//  Created by shams ahmed on 15/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Alamofire

/// Push notification routers
internal enum PushNotificationRouter: URLRequestConvertible {

    /// Supported device type
    internal enum DeviceType: String {
        case iOS = "ios"
        case android
    }
    
    /// API base url
    private static let baseURL = BaseURL.rest
    
    /// Fetch current user notification token
    case retrieveCertificate(applicationToken: String)
    
    /// Add/Update APNS certificate
    case upload(certificate: Data, password: String?, applicationToken: String)
    
    /// Remove all iOS APNS certificate for current user
    case removeAllCertificate(applicationToken: String)
    
    /// Add/Update user device token on server
    case updateDevice(id: String, deviceToken: Data)
    
    /// Remove all device token
    case deleteDeviceToken(id: String)
    
    // MARK:
    // MARK: Request
    
    private var method: HTTPMethod {
        switch self {
        case .retrieveCertificate(_): return .get
        case .upload(_, _, _): return .put
        case .removeAllCertificate(_): return .delete
        case .updateDevice(_, _): return .put
        case .deleteDeviceToken(_): return .delete
        }
    }
    
    private var path: String {
        switch self {
        case .retrieveCertificate(let applicationToken):
            return "/applications/\(applicationToken)/push_tokens/\(DeviceType.iOS.rawValue)"
        case .upload(_, _, let applicationToken):
            return "/applications/\(applicationToken)/push_tokens/\(DeviceType.iOS.rawValue)"
        case .removeAllCertificate(let applicationToken):
            return "/applications/\(applicationToken)/push_tokens/\(DeviceType.iOS.rawValue)"
        case .updateDevice(let id, _):
            return "/devices/\(id)"
        case .deleteDeviceToken(let id):
            return "/devices/\(id)"
        }
    }
    
    // MARK:
    // MARK: URLRequestConvertible
    
    /// Build request
    internal func asURLRequest() throws -> URLRequest {
        let url = try type(of: self).baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .retrieveCertificate(_):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .upload(let certificate, let password, _):
            urlRequest = try JSONEncoding.default.encode(
                urlRequest,
                with: PushNotificationBuilder.uploadParameter(certificate: certificate, password: password)
            )
        case .removeAllCertificate(_):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .updateDevice(_, let deviceToken):
            urlRequest = try JSONEncoding.default.encode(
                urlRequest,
                with: PushNotificationBuilder.updateParameter(token: deviceToken)
            )
        case .deleteDeviceToken(_):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        }
        
        return urlRequest
    }
}
