//
//  MembershipController.swift
//  NexmoConversation
//
//  Created by shams ahmed on 29/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import RxSwift

/// Controller to manage a user membership status
@objc
internal class MembershipController: NSObject {
    
    /// Network controller
    private let networkController: NetworkController
    
    /// Rx
    internal let disposeBag = DisposeBag()
    
    // MARK:
    // MARK: Initializers
    
    internal init(network: NetworkController) {
        networkController = network
    }
    
    // MARK:
    // MARK: Membership
    
    /// Invite user to a conversation
    ///
    /// - Parameter user: user id
    /// - Parameter for: conversation id
    /// - Returns: result
    internal func invite(user id: String, for conversationId: String) -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.networkController.membershipService.invite(user: id, conversationId: conversationId, success: { _ in
                observer.onNextWithCompleted()
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
            }
            .observeOnBackground()
    }
    
    /// Kick user out of a conversation
    ///
    /// - Parameter member: member id
    /// - Parameter in: conversation id
    /// - Returns: result
    internal func kick(_ member: String, in conversation: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            self.networkController.membershipService.kick(member, in: conversation, success: { result in
                observer.onNextWithCompleted(result)
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
            }
            .observeOnBackground()
    }
    
    /// Get details for a member in a conversation
    ///
    /// - Parameter for: member id
    /// - Parameter in: conversation Id
    /// - Returns: result with model or error
    internal func details(for member: String, in conversationId: String) -> Observable<MemberModel> {
        return Observable<MemberModel>.create { observer in
            self.networkController.membershipService.details(for: member, in: conversationId, success: { model in
                observer.onNextWithCompleted(model)
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
            }
            .observeOnBackground()
    }
}
