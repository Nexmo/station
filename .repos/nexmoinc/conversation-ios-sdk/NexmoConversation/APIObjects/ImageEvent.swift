//
//  ImageEvent.swift
//  NexmoConversation
//
//  Created by James Green on 06/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit

/// Image event
@objc(NXMImageEvent)
public class ImageEvent: TextEvent {
    
    // MARK:
    // MARK: Properties
    
    /// Image
    public private(set) var image: Data? {
        get { return data.payload }
        set { data.payload = newValue }
    }
    
    // MARK:
    // MARK: Initializers
    
    internal override init(conversationUuid: String, event: Event, seen: Bool) {
        super.init(conversationUuid: conversationUuid, event: event, seen: seen)
    }
    
    internal override init(data: DBEvent) {
        super.init(data: data)
    }
    
    internal init(conversationUuid: String, member: Member, isDraft: Bool, distribution: [String], seen: Bool) {
        super.init(conversationUuid: conversationUuid, type: .image, member: member, seen: seen)
       
        data.isDraft = isDraft
        data.distribution = distribution
    }
    
    internal init(conversationUuid: String, member: Member, isDraft: Bool, distribution: [String], seen: Bool, image: Data) {
        super.init(conversationUuid: conversationUuid, type: .image, member: member, seen: seen)
        
        self.image = image
    }
}
