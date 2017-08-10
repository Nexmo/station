//
//  RxApplicationDelegateProxy.swift
//  NexmoConversation
//
//  Created by shams ahmed on 24/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

@UIApplicationMain
internal class FakeUIApplicationDelegate: UIResponder, UIApplicationDelegate {
 
    // Singleton to mock UIApplicationDelegate
    internal static let shared = FakeUIApplicationDelegate()
    
    // MARK:
    // MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
}

/// Xcode caches when in unit test mode for SDK, this class fakes the check respond methods
internal class FakeUIApplicationDelegateProxy: DelegateProxy, DelegateProxyType, UIApplicationDelegate {
    internal static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        // Not in use
        return nil
    }
    
    internal static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        // Not in use
    }
}

/// Helper to proxy UIApplicationDelegate to SDK
internal class RxApplicationDelegateProxy: DelegateProxy, UIApplicationDelegate, DelegateProxyType {
    
    // MARK:
    // MARK: DelegateProxyType
    
    /// Returns designated delegate property for object.
    ///
    /// Objects can have multiple delegate properties.
    ///
    /// Each delegate property needs to have it's own type implementing `DelegateProxyType`.
    ///
    /// - parameter object: Object that has delegate property.
    /// - returns: Value of delegate property.
    internal static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        guard let application = object as? UIApplication else { return nil }
        
        return application.delegate
    }
    
    /// Sets designated delegate property for object.
    ///
    /// Objects can have multiple delegate properties.
    ///
    /// Each delegate property needs to have it's own type implementing `DelegateProxyType`.
    ///
    /// - parameter toObject: Object that has delegate property.
    /// - parameter delegate: Delegate value.
    internal static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) { 
        guard let application = object as? UIApplication, let delegate = delegate as? UIApplicationDelegate else { return }
        
        application.delegate = delegate
    }
    
    // MARK:
    // MARK: DelegateProxy
    
    /// Sets reference of normal delegate that receives all forwarded messages
    /// through `self`.
    ///
    /// - parameter forwardToDelegate: Reference of delegate that receives all messages through `self`.
    /// - parameter retainDelegate: Should `self` retain `forwardToDelegate`.
    internal override func setForwardToDelegate(_ delegate: AnyObject?, retainDelegate: Bool) {
        super.setForwardToDelegate(delegate, retainDelegate: true)
    }
}
