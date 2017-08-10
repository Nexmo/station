//
//  UIViewController+StoryboardIdentifiable.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 26/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit

/// Type safe approach to asigning view controller
protocol StoryboardIdentifiable {
    
    /// Class name
    static var storyboardIdentifier: String { get }
}

extension UIViewController: StoryboardIdentifiable {
    
}

extension StoryboardIdentifiable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
