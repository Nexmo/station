//
//  UIApplicationDelegate+Rx.swift
//  NexmoConversation
//
//  Created by shams ahmed on 24/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// Application State
///
/// - active: Application in foreground
/// - inactive: Foreground but not receiving events i.e user has opens notification center, phone call, system prompt
/// - background: Background
/// - terminated: Terminated
internal enum ApplicationState: Equatable {
    case active, inactive, background, terminated
}

/// Equality Application State
///
/// - Parameters:
///   - lhs: state
///   - rhs: state
/// - Returns: result of comparison
internal func ==(lhs: ApplicationState, rhs: ApplicationState) -> Bool {
    switch (lhs, rhs) {
    case (.active, .active),
         (.inactive, .inactive),
         (.background, .background),
         (.terminated, .terminated):
        return true
    case (.active, _),
         (.inactive, _),
         (.background, _),
         (.terminated, _): return false
    }
}

/// Push Notification State
///
/// - none: none
/// - registeredWithDeviceToken: token
/// - receivedRemoteNotification: payload
internal enum PushNotificationState {
    case unknown
    case registeredWithDeviceToken(Data)
    case registerForRemoteNotificationsFailed(Error)
    case receivedRemoteNotification(payload: [AnyHashable: Any]?, fetchCompletion: Any?) // ((UIBackgroundFetchResult) -> Void)
}

/// Payload from nexmo conversation
internal typealias RemoteNotification = (payload: [String: Any], fetchCompletion: Any?)

// Helper to get the current application state
internal extension RxSwift.Reactive where Base: UIApplication {
    
    // MARK:
    // MARK: Private - Delegate
    
    /// UIApplicationDelegate
    internal var delegate: DelegateProxy {
        // Unit test are only done on DEBUG mode
        if Environment.inDebug {
            let weakBase: UIApplication? = base
            
            // See class, for unit test purposes
            guard weakBase != nil else {
                Log.error(.other, "\(FakeUIApplicationDelegateProxy.self) test class is in use!")

                return FakeUIApplicationDelegateProxy(parentObject: FakeUIApplicationDelegate.shared)
            }
        }
        
        return RxApplicationDelegateProxy.proxyForObject(base)
    }

    // MARK:
    // MARK: Private - UIApplication State
    
    /// Application did become active
    private var applicationDidBecomeActiveNotification: Observable<ApplicationState> {
        return NotificationCenter.default.rx.notification(.UIApplicationDidBecomeActive).map { _ in .active }
    }
    
    // MARK:
    // MARK: Private - UIApplicationDelegate State
    
    /// State for when application is active
    private var applicationDidBecomeActive: Observable<ApplicationState> {
        return delegate.methodInvoked(#selector(UIApplicationDelegate.applicationDidBecomeActive(_:))).map { _ in .active }
    }
    
    /// State for when application is background
    private var applicationDidEnterBackground: Observable<ApplicationState> {
        return delegate.methodInvoked(#selector(UIApplicationDelegate.applicationDidEnterBackground(_:))).map { _ in .background }
    }
    
    /// State for when application is resigning active
    private var applicationWillResignActive: Observable<ApplicationState> {
        return delegate.methodInvoked(#selector(UIApplicationDelegate.applicationWillResignActive(_:))).map { _ in .inactive }
    }
    
    /// State for when application is terminating
    private var applicationWillTerminate: Observable<ApplicationState> {
        return delegate.methodInvoked(#selector(UIApplicationDelegate.applicationWillTerminate(_:))).map { _ in .terminated }
    }
    
    // MARK:
    // MARK: Push Notification
    
    /// Received remote notification observable
    internal var receiveRemoteNotification: Observable<PushNotificationState> {
        let remoteNotificationWithFetch = delegate
            .methodInvoked(#selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
            .map { value in PushNotificationState.receivedRemoteNotification(
                payload: value[1] as? [AnyHashable: Any],
                fetchCompletion: value[2])
        }
        
        let remoteNotification = delegate
            .methodInvoked(#selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:)))
            .map { PushNotificationState.receivedRemoteNotification(
                payload: $0[1] as? [AnyHashable: Any],
                fetchCompletion: nil)
        }
        
        return Observable.of(remoteNotificationWithFetch, remoteNotification).merge()
    }
    
    /// Registered for remote notifications device token observable
    internal var registeredForRemoteNotifications: Observable<PushNotificationState> {
        return delegate
            .methodInvoked(#selector(UIApplicationDelegate.application(_:didRegisterForRemoteNotificationsWithDeviceToken:)))
            .map { $0.last as? Data }
            .unwrap()
            .map { PushNotificationState.registeredWithDeviceToken($0) }
    }
    
    /// Register for remote notifications failed observable
    internal var registerForRemoteNotificationsFailed: Observable<PushNotificationState> {
        return delegate
            .methodInvoked(#selector(UIApplicationDelegate.application(_:didFailToRegisterForRemoteNotificationsWithError:)))
            .map { $0.last as? Error }
            .unwrap()
            .map { PushNotificationState.registerForRemoteNotificationsFailed($0) }
    }
    
    // MARK:
    // MARK: Application State
    
    /// Application state observable
    internal var applicationState: Observable<ApplicationState> {
        let becomeActive = Observable.of(applicationDidBecomeActive, applicationDidBecomeActiveNotification)
            .merge()
            .debounce(1, scheduler: MainScheduler.instance)
        
        return Observable.of(
            becomeActive,
            applicationWillResignActive,
            applicationDidEnterBackground,
            applicationWillTerminate
            )
            .merge()
    }
}
