//
//  IPSBuilder.swift
//  NexmoConversation
//
//  Created by shams ahmed on 29/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Alamofire

/// Build payload for IPS
internal struct IPSBuilder {
    
    // MARK:
    // MARK: Builder
    
    /// Create payload for upload request
    internal static func uploadParameter(formData: MultipartFormData, parameters: IPSService.UploadImageParameter) {
        guard let originalRatio = String(parameters.size.originalRatio ?? 100).data(using: .utf8),
            let mediumRatio = String(parameters.size.mediumRatio ?? 50).data(using: .utf8),
            let thumbnailRatio = String(parameters.size.thumbnailRatio ?? 10).data(using: .utf8) else { return }
        
        // ratio are aligned to JS and Android SDK [Sept 16]
        formData.append(originalRatio, withName: "quality_ratio")
        formData.append(mediumRatio, withName: "medium_size_ratio")
        formData.append(thumbnailRatio, withName: "thumbnail_size_ratio")
        
        formData.append(parameters.image, withName: "file", fileName: "\(arc4random()).jpeg", mimeType: "image/jpeg")
    }
}
