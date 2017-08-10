//
//  Avatar.swift
//  NexmoChat
//
//  Created by James Green on 26/05/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import NexmoConversation

@IBDesignable public class AvatarWidget: UIImageView {
    private var _user: User?
    private var _conversation: Conversation?
    
    static private var allocatedImages: [String: UIImage] = [:]
    static private var allocationIndex = 0
    static private let maxAllocation = 7
    
    /**
     Property to set this avatar to a particular user.
      */
    public var user: User? {
        get {
            return _user
        }
        set {
            _conversation = nil
            _user = newValue
            
            if _user == nil {
                image = UIImage(named: "DefaultUserAvatar")
            } else {
                /* Code to give a temporary avatar in the absence of SDK support. */
                let userId: String = (_user?.uuid)!
                
                /* See if we've already allocated an image for this user? */
                var asset: UIImage? = AvatarWidget.allocatedImages[userId]
                
                if asset == nil {
                    AvatarWidget.allocationIndex += 1
                    if AvatarWidget.allocationIndex > AvatarWidget.maxAllocation {
                        AvatarWidget.allocationIndex = 1
                    }
                    
                    asset = UIImage(named: String(format: "Avatar%d", AvatarWidget.allocationIndex))
                    AvatarWidget.allocatedImages[userId] = asset
                }
                
                image = asset
            }
        }
    }

    /**
     Property to set this avatar to a particular conversation.
     */
    public var conversation: Conversation? {
        get {
            return _conversation
        }
        set {
            _user = nil
            _conversation = newValue
            
            if _conversation == nil {
                image = UIImage(named: "DefaultConversationAvatar")
            } else {
                /* Code to give a temporary avatar in the absence of SDK support. */
                let id: String = (_conversation?.uuid)!
                
                /* See if we've already allocated an image for this user? */
                var asset: UIImage? = AvatarWidget.allocatedImages[id]
                if asset == nil {
                    AvatarWidget.allocationIndex += 1
                    if AvatarWidget.allocationIndex > AvatarWidget.maxAllocation {
                        AvatarWidget.allocationIndex = 1
                    }
                    
                    asset = UIImage(named: String(format: "Avatar%d", AvatarWidget.allocationIndex))
                    AvatarWidget.allocatedImages[id] = asset
                }
                
                image = asset
            }
        }
    }
    
    /**
     Standard constructor.
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        constructCommon()
    }
    
    /**
     Standard constructor.
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        constructCommon()
    }
    
    /**
     Helper to hold common code for constructors.
     */
    private func constructCommon() {
        layer.borderWidth = 2
        layer.borderColor = Styling.AVATAR_BORDER_COLOR.cgColor
        contentMode = .scaleAspectFill
        clear()
    }
    
    /**
     Clear the image back to the default.
     */
    public func clear() {
        conversation = nil
        user = nil
    }
    
    /**
     Whenever we are resized make sure the corners are suitably rounded.
     */
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = (frame.size.width / 2)
        layer.masksToBounds = true
    }
}
