//
//  AppConfigurator.swift
//  ConversationDemo
//
//  Created by shams ahmed on 19/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Bugsnag
import Watchdog
import UIKit
import NexmoConversation
import netfox

/// App Configurator
internal class AppConfigurator: NSObject {
    
    /// App launch options
    private let launchOptions: [UIApplicationLaunchOptionsKey : Any]?
    
    /// Conversation client
    private let conversationClient: ConversationClient
    
    /// Testing for main thread locks
    private let watchdog = Watchdog()
    
    // MARK:
    // MARK: Initializers
    
    internal init(launchOptions: [UIApplicationLaunchOptionsKey : Any]?, conversationClient: ConversationClient) {
        self.launchOptions = launchOptions
        self.conversationClient = conversationClient
        
        super.init()
        
        setup()
    }
    
    // MARK:
    // MARK: Setup
    
    private func setup() {
        DispatchQueue.global(qos: .background).async {
            self.setupReporters()
            self.setupPushNotification()
        }
    }
    
    private func setupReporters() {
        #if RELEASE
            if let key = Constants.Bugsnag.key {
                Bugsnag.start(withApiKey:Constants.Bugsnag.key)
                Bugsnag.configuration()?.appVersion = Constants.App.version
            }
        #endif
        
        NFX.sharedInstance().start()
        NFX.sharedInstance().setGesture(.custom)
    }
    
    private func setupPushNotification() {
        let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        
        UIApplication.shared.registerForRemoteNotifications()
        UIApplication.shared.registerUserNotificationSettings(setting)
    }
    
    // MARK:
    // MARK: Swizzle
    
    internal static func swizzleMethods() {
        let class1: AnyClass? = NSClassFromString("NexmoConversation.SessionConfiguration")
        let class2: AnyClass? = NSClassFromString("ConversationDemo.AppConfigurator")
        
        // Add another protocol to listen for network events without effecting the SDK
        Swizzle.method(
            (selector: NSSelectorFromString("setup:"), forClass: class1),
            with: (selector: #selector(AppConfigurator.addNetworkLogging(_:)), forClass: class2)
        )
    }
    
    // MARK:
    // MARK: Network logs
    
    @objc
    private func addNetworkLogging(_ configuration: URLSessionConfiguration) -> URLSessionConfiguration {
        configuration.protocolClasses?.insert(NFXProtocol.self, at: 0)
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20

        return configuration
    }
}
