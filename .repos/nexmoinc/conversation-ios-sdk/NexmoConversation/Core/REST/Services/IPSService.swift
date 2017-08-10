//
//  IPSService.swift
//  NexmoConversation
//
//  Created by shams ahmed on 29/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Alamofire

/// Service for exposing iPS calls
internal struct IPSService {
    
    /// Upload parameters, by default setting nil for value will set:
    ///
    /// originalRatio: Range from 1 to 100, Default value:
    /// mediumRatio: Range from 1 to 100, Default value:
    /// thumbnailRatio: Range from 1 to 100, Default value:
    internal typealias Parameters = (originalRatio: Int?, mediumRatio: Int?, thumbnailRatio: Int?)
    
    /// Parameter for uploading images to IPS
    internal typealias UploadImageParameter = (image: Data, size: Parameters)
    
    /// Network manager
    private let manager: HTTPSessionManager
    
    // MARK:
    // MARK: Initializers
    
    init(manager: HTTPSessionManager) {
        self.manager = manager        
    }
    
    // MARK:
    // MARK: POST
    
    /// Upload image to IPS
    ///
    /// - parameter parameter: image ratio setting
    /// - parameter success:   uploaded image model
    /// - parameter failure:   failure resons
    internal func upload(image: UploadImageParameter, success: @escaping (UploadedImage) -> Void, failure: @escaping (Error) -> Void) {
        manager.upload(
            multipartFormData: { IPSBuilder.uploadParameter(formData: $0, parameters: image) },
            with: IPSRouter.upload(),
            encodingCompletion: { result in
                guard case .success(let request, _, _) = result else { return failure(HTTPSessionManager.Errors.malformedJSON) }
                
                request
                    .validateAndReportError(to: self.manager)
                    .responseJSON(queue: self.manager.queue, completionHandler: { response in
                        switch response.result {
                        case .success(let response):
                            guard let json = response as? Alamofire.Parameters, let model = UploadedImage(json: json) else {
                                return failure(HTTPSessionManager.Errors.malformedJSON)
                            }
                            
                            success(model)
                        case .failure(let error):
                            failure(NetworkError(from: response) ?? error)
                        }
                })
        })
    }
}
