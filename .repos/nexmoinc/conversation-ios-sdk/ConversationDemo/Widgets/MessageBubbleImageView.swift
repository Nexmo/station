//
//  MessageBubbleImageView.swift
//  NexmoChat
//
//  Created by James Green on 27/05/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import NexmoConversation

public class MessageBubbleImageView: MessageBubbleView {
    /**
     Constructor.
     
     - parameter message: The message.
     
     - returns: A new instance.
     */
    required public init(message: ImageEvent, onLeft: Bool, parentWidth: CGFloat, avatarEnabled: Bool, name: String?) {
        super.init(onLeft: onLeft, message: message, parentWidth: parentWidth, avatarEnabled: avatarEnabled, name: name)
        
        /* Create the image for the payload, and make it fill its superview. */
        let image: UIImage? = {
            guard let data = message.image else { return nil }
            
            return UIImage(data: data)
        }()
        
        let imageView = UIImageView(image: image)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        payloadContainer.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        payloadContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[imageView]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["imageView": imageView]))
        payloadContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[imageView]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["imageView": imageView]))
    }
    
    /**
     Returns an object initialized from data in a given unarchiver.
     
     - parameter aDecoder: An unarchiver object.
     
     - returns: self, initialized using the data in decoder.
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    /**
     For the given message (containing an image), what would we like the height of the payload container to be?
     
     - parameter image:     image
     - parameter parentWidth: Width of table (not payload container)
     
     - returns: The height
     */
    public static func payloadHeightFor(image: UIImage, parentWidth: CGFloat) -> CGFloat {
        let width = payloadWidthFor(image: image, availableWidth: parentWidth)
        let height = (image.size.height * width) / image.size.width
        
        return height
    }

    /**
     For the given message (containing an image), what would we like the width of the payload container to be?
     
     - parameter image:        image
     - parameter availableWidth: Current/default width of payload container
     
     - returns: The width we'd like it to be (not exceeding the current width)
     */
    public static func payloadWidthFor(image: UIImage, availableWidth: CGFloat) -> CGFloat {
        return min(availableWidth, 150)
    }
}
