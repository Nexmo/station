//
//  AppLifecycleController.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 26/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// Controller to handle common life cycle event while making there developer life easier i.e UIApplicationDelegate
internal class AppLifecycleController {
    
    /// App push notification state
    internal var pushNotificationState = PushNotificationState.unknown
    
    /// Rx
    private let disposeBag = DisposeBag()
    
    /// Registered for remote notifications device token observable
    internal lazy var registeredForRemoteNotifications: Observable<PushNotificationState> = {
        return UIApplication.shared.rx.registeredForRemoteNotifications
            .observeOnBackground()
            .share()
    }()
    
    /// Registered for remote notifications device token observable
    internal lazy var receiveRemoteNotification: Observable<RemoteNotification> = {
        return UIApplication.shared.rx.receiveRemoteNotification
            .observeOnBackground()
            .filter { state in
                // Look for Nexmo Conversation key
                guard case .receivedRemoteNotification(let payload, _) = state,
                    payload?[Constants.SDK.name] as? [String: Any] != nil else { return false }
                
                return true
            }
            .map { state -> RemoteNotification in
                guard case .receivedRemoteNotification(let payload, let completion) = state,
                    // Since we done the checks in the filter closure, we always get back the data
                    let data = payload?[Constants.SDK.name] as? [String: Any] else {
                        return RemoteNotification(payload: [:], fetchCompletion: nil)
                }
                
                return RemoteNotification(payload: data, fetchCompletion: completion)
            }
            .share()
    }()
    
    /// Application state
    internal let applicationState: Observable<ApplicationState> = UIApplication.shared.rx.applicationState.share()
    
    // MARK:
    // MARK: Initializers

    internal init() {
        setup()
    }

    // MARK:
    // MARK: Private - Setup
    
    private func setup() {
    
    }
}
