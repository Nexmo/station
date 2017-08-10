//
//  UploadedImage.swift
//  NexmoConversation
//
//  Created by shams ahmed on 25/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Gloss

/// Uploaded image model from media server
public struct UploadedImage: Glossy {
    
    // MARK:
    // MARK: Enum
    
    /// Types of images sent from server
    ///
    /// - original: original
    /// - medium: medium
    /// - thumbnail: thumbnail
    public enum ImageType: String, Equatable {
        case original, medium, thumbnail
        
        /// Compare ImageType
        static public func == (lhs: ImageType, rhs: ImageType) -> Bool {
            switch (lhs, rhs) {
            case (.original, .original): return true
            case (.medium, .medium): return true
            case (.thumbnail, .thumbnail): return true
            case (.original, _),
                 (.medium, _),
                 (.thumbnail, _): return false
            }
        }
    }

    /// Type of images available
    ///
    /// - link: link with image data and size
    public enum Image: Equatable {
        case link(id: String, url: URL, type: ImageType, size: Int)
    
        /// Compare Image Link
        static public func ==(lhs: Image, rhs: Image) -> Bool {
            switch (lhs, rhs) {
            case (.link(let id0, let url0, let type0, let size0), .link(let id1, let url1, let type1, let size1)):
            return id0 == id1 && url0 == url1 && type0 == type1 && size0 == size1
        }
    }
        // MARK:
        // MARK: Initializers
        
        /// create image location model
        ///
        /// - parameter json: json
        ///
        /// - returns: image model
        public static func create(json: JSON) -> Image? {
            guard let type: String = "type" <~~ json,
                let imageType = ImageType(rawValue: type.lowercased()) else {
                return nil
            }
            
            guard let id: String = "id" <~~ json,
                let url: URL = "url" <~~ json,
                let size: Int = "size" <~~ json else {
                return nil
            }
            
            return Image.link(id: id,
                              url: url,
                              type: imageType,
                              size: size)
        }
        
        // MARK:
        // MARK: JSON
        
        /// Convert model to JSON
        public var toJSON: JSON {
            switch self {
            case .link(let id, let url, let type, let size):
                return [
                    "url": url.absoluteString,
                    "id": id,
                    "type": type.rawValue,
                    "size": size
                ]
            }
        }
    }
    
    // MARK:
    // MARK: Properties
    
    /// Id of uploaded image location
    public let id: String
    
    /// All available images, use method instead
    private let images: [UploadedImage.Image]
    
    // MARK:
    // MARK: Initializers
    
    public init?(json: JSON) {
        guard let id: String = "id" <~~ json else { return nil }
        
        self.id = id
        
        self.images = [json[ImageType.medium.rawValue], json[ImageType.thumbnail.rawValue], json[ImageType.original.rawValue]]
            .flatMap { $0 as? JSON }
            .flatMap { Image.create(json: $0) }
    }
    
    // MARK:
    // MARK: Helper

    /// Get image from a type
    ///
    /// - parameter type: image type
    ///
    /// - returns: image model
    public func image(for type: ImageType) -> UploadedImage.Image? {
        return images.first(where: {
            guard case .link(_, _, let imageType, _) = $0, imageType == type else { return false }
            
            return true
        })
    }
    
    // MARK:
    // MARK: JSON
    
    /// Convert model to JSON
    public func toJSON() -> JSON? {
        guard let thumbnail = image(for: .thumbnail),
            let original = image(for: .original),
            let medium = image(for: .medium) else { return nil }
        
        return jsonify([
            "id" ~~> id,
            "original" ~~> original.toJSON,
            "medium" ~~> medium.toJSON,
            "thumbnail" ~~> thumbnail.toJSON
            ])
    }
}
