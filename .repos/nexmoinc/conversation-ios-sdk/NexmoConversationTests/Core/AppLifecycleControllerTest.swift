//
//  AppLifecycleControllerTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 01/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble
import Mockingjay
import RxTest
import RxBlocking
@testable import NexmoConversation

internal class AppLifecycleControllerTest: QuickSpec {
    
    let appLifeCycleController = AppLifecycleController()
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("compare application state matches") {
            let result = ApplicationState.active == ApplicationState.active
            
            expect(result) == true
        }
        
        it("fail application state match check") {
            let result = ApplicationState.active == ApplicationState.terminated
            
            expect(result) == false
        }

        // DISABLED
        it("receives remote notifications passes") {
            var newNotification: RemoteNotification?
            
            // TODO: add fake uiapplication mock
            _ = self.appLifeCycleController.receiveRemoteNotification.subscribe(onNext: { notification in
                newNotification = notification
            })
            
            let clourse: () -> Bool = {
                FakeUIApplicationDelegate.shared.perform(#selector(FakeUIApplicationDelegate.application(_:didRegisterForRemoteNotificationsWithDeviceToken:)), with: Data())
                
                // TODO: add feature to call fake object and make subscriber process info
                return false
            }
            
            expect(clourse()).toEventuallyNot(beFalse())
            expect(newNotification).toEventuallyNot(beNil())
        }

        // DISABLED
        it("registers for remote notifications") {
            var newState: PushNotificationState?
            
            // TODO: add fake uiapplication mock
            _ = self.appLifeCycleController.registeredForRemoteNotifications.subscribe(onNext: { state in
                newState = state
            })
            
            expect(newState).toEventuallyNot(beNil())
        }

        it("fails to register for remote notifications") {
            var newState: PushNotificationState?
            
            _ = UIApplication.shared.rx.registerForRemoteNotificationsFailed.subscribe(onNext: { state in
                newState = state
            })
            
            expect(newState).toEventually(beNil())
        }

        // DISABLED
        it("receives application state") {
            var newState: ApplicationState?
            // TODO: add fake uiapplication mock
            _ = self.appLifeCycleController.applicationState.subscribe(onNext: { state in
                newState = state
            })
            
            expect(newState).toEventuallyNot(beNil())
        }
    }
}
