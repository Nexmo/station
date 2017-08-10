//
//  UIStoryboard+Helper.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 26/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit

// MARK: - Helper to avoid using hard-coded string's all over the codebase
internal extension UIStoryboard {
    
    /// Storyboard
    ///
    /// - main: main demo app storyboard
    internal enum Storyboard: String {
        case main = "Main"
    }
    
    // MARK:
    // MARK: Initializers
    
    internal convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }
    
    internal class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
    }
    
    // MARK:
    // MARK: View Controller
    
    /// Instantiate view controller
    ///
    /// - Returns: View Controller
    internal func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            // fine to have fatal error here, since it controlled and tested in development
            fatalError("Couldn't instantiate view controller with identifier: \(T.storyboardIdentifier)")
        }
        
        return viewController
    }
}
