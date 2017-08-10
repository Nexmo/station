//
//  String+Helper.swift
//  NexmoConversation
//
//  Created by shams ahmed on 11/11/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import UIKit

internal extension String {
    
    internal func boundingBox(availableWidth: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: availableWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: [NSFontAttributeName: font], context: nil
        )
        
        return boundingBox.size
    }
}
