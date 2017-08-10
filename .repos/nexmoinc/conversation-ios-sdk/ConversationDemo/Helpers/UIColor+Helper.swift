//
//  UIColor+Helper.swift
//  NexmoConversation
//
//  Created by shams ahmed on 11/11/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import UIKit

internal extension UIColor {
    
    // MARK:
    // MARK: Initializers
    
    internal convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    internal convenience init(netHex: Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    // MARK:
    // MARK: Color
    
    internal func withAlpha(_ alpha: CGFloat) -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var dummyAlpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &dummyAlpha)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
