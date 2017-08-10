//
//  AccountController.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 28/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import RxSwift

/// Account controller to handle all account actions
@objc(NXMAccountController)
public class AccountController: NSObject {
    
    // MARK:
    // MARK: Enum
    
    /// Account state
    ///
    /// - loggedOut: user is not logged into capi
    /// - loggedIn: user has been logged into capi, parameter includes session model
    public enum State: Equatable {
        case loggedOut
        case loggedIn(Session)
    }
    
    // MARK:
    // MARK: Properties
    
    /// Nexmo application id
    public static var applicationId: String {
        guard !Environment.inTesting else {
            Log.info(.other, "Application Id has not been set, push notification support will be disabled.")

            return ""
        }

        guard let nexmo = Bundle.main.object(forInfoDictionaryKey: Constants.Keys.nexmoDictionary) as? [String : Any],
            let applicationID = nexmo[Constants.Keys.applicationID] as? String else {
            Log.info(.other, "Application Id has not been set, push notification support will be disabled.")

            return ""
        }

        return applicationID
    }
    
    /// API session token
    public internal(set) var token: String? {
        get {
            return Keychain()[.token]
        }
        set {
            if let newValue = newValue {
                Keychain()[.token] = newValue
            } else {
                Keychain().remove(forKey: .token)
            }
        }
    }
    
    /// User id of current user
    internal internal(set) var userId: String? {
        get {
            let username = Keychain()[.username]
            
            return username
        }
        set {
            if let newValue = newValue {
                Keychain()[.username] = newValue
            } else {
                Keychain().remove(forKey: .username)
            }
        }
    }
    
    /// Current logged in User
    public var user: User? {
        guard let userId = userId else { return nil }
        
        assert(self.cacheManager != nil, "cacheManager not been set post init method")
        
        return self.cacheManager?.userCache.get(uuid: userId)
    }
    
    /// Network controller
    private let networkController: NetworkController
    internal weak var cacheManager: CacheManager?
    
    /// Rx
    internal let disposeBag = DisposeBag()
    
    // MARK:
    // MARK: Properties - Observable

    /// User login state
    public let state = Variable<State>(.loggedOut)

    // MARK:
    // MARK: Initializers
    
    internal init(network: NetworkController) {
        networkController = network
    }
    
    // MARK:
    // MARK: Account
    
    /// Remove all user information from device
    public func removeUserData() {
        token = nil
        networkController.token = ""
    }
    
    // MARK:
    // MARK: Device Token
    
    /// Add device token
    ///
    /// - Parameters:
    ///   - deviceToken: token
    ///   - deviceId: unique device id i.e UIDevice.currentDevice.identifierForVendor?.uuidString or a custom id
    /// - Returns: result of updating device token
    @discardableResult
    public func update(deviceToken: Data, deviceId: String?) -> Observable<Bool> {
        guard let deviceId = deviceId else { return Observable<Bool>.just(false) }
        
        return Observable<Bool>.create { observer in
            self.networkController.pushNotificationService.update(deviceToken: deviceToken, deviceId: deviceId, success: {
                observer.onNextWithCompleted(true)
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        }
    }
    
    /// Remove device token with your given device iD
    ///
    /// - Parameter id: unique device id i.e UIDevice.currentDevice.identifierForVendor?.uuidString or a custom id
    public func removeDeviceToken(id: String) -> Bool {
        networkController.pushNotificationService.removeDeviceToken(deviceId: id)
        
        return true
    }
    
    // MARK:
    // MARK: User
    
    /// Fetch user with a uuid
    ///
    /// - Parameters:
    ///   - uuid: user uuid
    /// - Returns: observable with status result
    internal func user(with id: String) -> Observable<UserModel> {
        return Observable<UserModel>.create { observer in
            self.networkController.accountService.user(
                with: id,
                success: { observer.onNextWithCompleted($0) },
                failure: { observer.onError($0) }
            )
            
            return Disposables.create()
        }
        .observeOnBackground()
    }
}

/// Compare login state
///
/// - Parameters:
///   - lhs: state
///   - rhs: state
/// - Returns: result
public func ==(lhs: AccountController.State, rhs: AccountController.State) -> Bool {
    switch (lhs, rhs) {
    case (.loggedOut, .loggedOut): return true
    case (.loggedIn, .loggedIn): return true
    case (.loggedOut, _),
         (.loggedIn, _): return false
    }
}
