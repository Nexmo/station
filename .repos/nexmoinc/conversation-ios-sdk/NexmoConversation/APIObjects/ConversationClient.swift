//
//  ConversationClient.swift
//  NexmoConversation
//
//  Created by James Green on 22/08/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import RxSwift

/// Compare state
///
/// - Parameters:
///   - lhs: lhs state
///   - rhs: rhs state
/// - Returns: result of comparison
public func ==(lhs: ConversationClient.State, rhs: ConversationClient.State) -> Bool {
    switch (lhs, rhs) {
    case (.disconnected, .disconnected): return true
    case (.connecting, .connecting): return true
    case (.connected, .connected): return true
    case (.outOfSync, .outOfSync): return true
    case (.synchronizing(let lhs), .synchronizing(let rhs)):
        switch (lhs, rhs) {
        case (.conversations, .conversations): return true
        case (.events, .events): return true
        case (.members, .members): return true
        case (.users, .users): return true
        case (.receipts, .receipts): return true
        case (.tasks, .tasks): return true
        case (.conversations, _),
             (.events, _),
             (.members, _),
             (.users, _),
             (.receipts, _),
             (.tasks, _): return false
        }
    case (.synchronized, .synchronized): return true
    case (.disconnected, _),
         (.connecting, _),
         (.connected, _),
         (.outOfSync, _),
         (.synchronizing, _),
         (.synchronized, _): return false
    }
}

/// Conversation Client main interface
@objc(NXMConversationClient)
public class ConversationClient: NSObject {

    // MARK:
    // MARK: Typealias
    
    /// Callback for response of logging into CAPI
    public typealias LoginResponse = (LoginResult) -> Void
    
    // MARK:
    // MARK: Enum
    
    internal enum Errors: Error, Equatable {
        case userNotInCorrectState
        case networking
        case busy
        case unknown(String?)
        
        /// Compare errors
        static internal func == (lhs: Errors, rhs: Errors) -> Bool {
            switch (lhs, rhs) {
            case (.userNotInCorrectState, .userNotInCorrectState): return true
            case (.networking, networking): return true
            case (.busy, busy): return true
            case (.unknown, unknown): return true
            case (.userNotInCorrectState, _),
                 (.networking, _),
                 (.busy, _),
                 (.unknown, _): return false
            }
        }
    }
    
    /// LoginResponse state
    ///
    /// - success: successful
    /// - failed: failed for unknown
    /// - invalidToken: token is invalid
    /// - sessionInvalid: session is invalid
    /// - expiredToken: token expired
    @objc(NXMLoginResult)
    public enum LoginResult: Int, Error {
        case success
        case failed
        case invalidToken
        case sessionInvalid
        case expiredToken
    }
    
    /// Global state of client
    ///
    /// - disconnected: Default state SDK has disconnected from all services. triggered on user logout/disconnects and inital state
    /// - connecting: Requesting permission to reconnect
    /// - connected: Connected to all services
    /// - outOfSync: SDK is not in sync yet
    /// - synchronizing: Synchronising with current progress state
    /// - synchronized: Synchronised all services and now ready
    public enum State: Equatable {
        case disconnected
        case connecting
        case connected
        case outOfSync
        case synchronizing(SynchronizingState)
        case synchronized
        
        // MARK:
        // MARK: String
        
        public var stringValue: String {
            switch self {
            case .disconnected: return "disconnected"
            case .connecting: return "connecting"
            case .connected: return "connected"
            case .outOfSync: return "outOfSync"
            case .synchronizing(let state): return state.rawValue
            case .synchronized: return "synchronized"
            }
        }
    }
    
    // MARK:
    // MARK: Shared
    
    /// A static instance (singleton) to access the ConversationClient.
    public static let instance: ConversationClient = ConversationClient()

    // MARK:
    // MARK: Configurations

    /*
     Client configuration
     warning: can only be set before calling ConversationClient.instance or ConversationClient()
     */
    public static var configuration: Configuration = Configuration.default
    
    // MARK:
    // MARK: Properties
    
    /// Controller to listen to lifecycle actions from application
    internal let appLifeCycleController = AppLifecycleController()
    
    internal let objectCache: CacheManager
    internal let syncManager: SyncManager
    internal let databaseManager = DatabaseManager()
    internal let eventQueue: EventQueue
    internal let networkController: NetworkController
    
    /// Controller to handle user account task
    public let account: AccountController
    
    /// Controller to handle events from a conversation
    internal let eventController: EventController
    
    /// Controller for handling socket events
    internal let socketController: SocketController
    
    /// Controller to handle user membership status
    internal let membershipController: MembershipController
    
    /// Controller to handle conversation request for network, cache, database
    public let conversation: ConversationController

    /// Login callback, set to nil after call
    internal(set) var loginCallback: LoginResponse?
    
    // MARK:
    // MARK: Properties - Observable
    
    /// State of client
    public let state: Variable<State> = Variable<State>(.disconnected)
    
    /// Internal error
    public var unhandledError: Observable<NetworkErrorProtocol> {
        return networkController.networkError.asObservable().skip(1).unwrap().share()
    }
    
    // MARK:
    // MARK: Disposable
    
    /// Shared disposable bag
    public let disposeBag = DisposeBag()
    
    // MARK:
    // MARK: Initializers
    
    @discardableResult
    private override init() {
        networkController = NetworkController()
        account = AccountController(network: networkController)
        conversation = ConversationController(network: networkController, account: account)
        eventController = EventController(network: networkController)
        membershipController = MembershipController(network: networkController)
        
        objectCache = CacheManager(databaseManager: databaseManager,
                                   eventController: eventController,
                                   account: account,
                                   conversation: conversation,
                                   membershipController: membershipController
        )
        
        eventQueue = EventQueue(cache: objectCache, event: eventController, database: databaseManager)
        
        syncManager = SyncManager(
            conversation: conversation, 
            account: account, 
            eventController: eventController,
            membershipController: membershipController,
            cache: objectCache,
            databaseManager: databaseManager,
            eventQueue: eventQueue
        )
        
        socketController = SocketController(
            socketService: networkController.socketService,
            subscriptionService: networkController.subscriptionService
        )
        
        account.cacheManager = objectCache
        objectCache.eventQueue = eventQueue
        conversation.conversations.cache = objectCache
        conversation.syncManager = syncManager
        
        super.init()
        
        setup()
    }
    
    // MARK:
    // MARK: Private - Setup

    private func setup() {
        setupApplicationBinding()
        setupClientBinding()
        setupEventBinding()
        setupAdditionalBinding()
        
        if Configuration.default.autoReconnect {
            setupReachabilityBinding()
        }
    }
    
    private func setupClientBinding() {
        networkController.socketState.asDriver().asObservable().skip(1).subscribe(onNext: {
            switch $0 {
            case .connecting:
                self.state.tryWithValue = .connecting
            case .authentication:
                self.state.tryWithValue = .connecting
            case .connected(let session):
                self.state.tryWithValue = .connected
                self.account.userId = session.userId
                self.account.state.value = .loggedIn(session)
                
                self.syncManager.start()
                self.eventQueue.start()
                
                DispatchQueue.main.async {
                    self.loginCallback?(.success)
                    self.loginCallback = nil
                }
            case .notConnected(let reason):
                self.state.tryWithValue = .disconnected
                
                DispatchQueue.main.async {
                    switch reason {
                    case .invalidToken:
                        self.loginCallback?(.invalidToken)
                        self.logout()
                    case .sessionInvalid:
                        self.loginCallback?(.sessionInvalid)
                        self.logout()
                    case .expiredToken:
                        self.loginCallback?(.expiredToken)
                        self.logout()
                    case .timeout, .connectionLost, .unknown(_):
                        self.loginCallback?(.failed)
                    }

                    self.loginCallback = nil
                }
            case .disconnected:
                self.state.tryWithValue = .disconnected
            }
        }).addDisposableTo(disposeBag)
        
        syncManager.state.asDriver().asObservable().skip(1).subscribe(onNext: { state in
            switch state {
            case .inactive: self.state.tryWithValue = .synchronized
            case .failed: self.state.tryWithValue = .outOfSync
            case .active(let state) where !(self.state.value == .synchronized): self.state.tryWithValue = .synchronizing(state)
            default: break
            }
        }).addDisposableTo(disposeBag)
    }
    
    private func setupEventBinding() {
        networkController.subscriptionService.events.asObservable()
            .unwrap()
            .flatMap { self.syncManager.receivedEvent($0) }
            .subscribe()
            .addDisposableTo(disposeBag)
    }
    
    private func setupApplicationBinding() {
        appLifeCycleController.applicationState
            .subscribeOnBackground()
            .flatMap { state -> Single<Void> in
                switch state {
                case .active: return self.login().catchError { _ in Single<Void>.just(()) }
                case .inactive: self.disconnect()
                default: break
                }
                
                return Single<Void>.just(())
            }
            .subscribe()
            .addDisposableTo(disposeBag)
        
        appLifeCycleController.receiveRemoteNotification
            .subscribeOnBackground()
            .flatMap { notification -> Observable<Event> in
                // TOOD: create model out of payload
                guard let rawtype = notification.payload["type"] as? String,
                    let type = Event.EventType(rawValue: rawtype),
                    let event = Event(type: type, json: notification.payload) else {
                    return Observable<Event>.never()
                }
                
                return Observable<Event>.just(event)
            }
            .flatMap { self.syncManager.receivedEvent($0) }
            .subscribe()
            .addDisposableTo(disposeBag)
        
        appLifeCycleController.registeredForRemoteNotifications
            .filter { _ in
                guard case .loggedIn(_) = self.account.state.value else { return false }
                
                return true
            }
            .map { state -> Data? in
                guard case PushNotificationState.registeredWithDeviceToken(let token) = state else { return nil }
                
                return token
            }
            .unwrap()
            .subscribeOnBackground()
            .subscribe(onNext: { [unowned self] token in
                self.account.update(deviceToken: token, deviceId: UIDevice.current.identifierForVendor?.uuidString)
            }).addDisposableTo(disposeBag)
    }
    
    private func setupAdditionalBinding() {
        // Hack to fix issue where login not been called due to delayed binding of UIApplication
        Observable<Int>.timer(0.5, scheduler: MainScheduler.asyncInstance)
            .filter { _ in self.state.value == .disconnected }
            .flatMap { _ in self.login().asDriver(onErrorJustReturn:()) }
            .subscribeOnBackground()
            .subscribe()
            .addDisposableTo(disposeBag)
    }
    
    private func setupReachabilityBinding() {
        networkController.networkState.asObservable()
            .scan((.failed, networkController.networkState.value)) { (lastEvent, newElement) -> (ReachabilityManager.State, ReachabilityManager.State) in
                let (_, oldElement) = lastEvent
                return (oldElement, newElement)
            }
            .subscribe(onNext: { [weak self] (old, new) in
                Log.info(.other, "Network state changed from \(old) to \(new)")
                
                // see if we need to trigger a reconnect
                if old == .notReachable && new.isReachable {
                    self?.reconnect()
                }
            }).addDisposableTo(disposeBag)
    }
    
    // MARK:
    // MARK: Client
    
    private func reconnect() {
        switch networkController.socketState.value {
        case .notConnected: networkController.connect()
        default: break
        }
        
        switch syncManager.state.value {
        case .inactive, .failed:
            self.state.tryWithValue = .outOfSync
            eventQueue.reconnect()
            syncManager.reconnect()
        default: break
        }
    }

    /// Close this library, and free all its resources. It cannot be used again after calling close().
    public func disconnect() {
        eventQueue.close()
        syncManager.close()
        networkController.disconnect()
        objectCache.clear()
    }
}
