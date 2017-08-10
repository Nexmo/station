//
//  ClientListener.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 26/05/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import RxSwift
@testable import NexmoConversation

internal struct ClientListener {

    internal static let `default` = ClientListener()

    private let disposeBag = DisposeBag()

    // MARK:
    // MARK: Initializers

    private init() {
        setup()
    }

    // MARK:
    // MARK: Setup

    private func setup() {
        loginState()
        clientState()
        eventQueueState()
        syncState()
    }

    // MARK:
    // MARK: Listener

    private func loginState() {
        ConversationClient.instance.account.state
            .asDriver()
            .debug()
            .asObservable()
            .subscribe()
            .addDisposableTo(disposeBag)
    }

    private func clientState() {
        ConversationClient.instance.state
            .asDriver()
            .debug()
            .asObservable()
            .subscribe()
            .addDisposableTo(disposeBag)
    }

    private func eventQueueState() {
        ConversationClient.instance.eventQueue.state
            .asDriver()
            .debug()
            .asObservable()
            .subscribe()
            .addDisposableTo(disposeBag)
    }

    private func syncState() {
        ConversationClient.instance.syncManager.state
            .asDriver()
            .debug()
            .asObservable()
            .subscribe()
            .addDisposableTo(disposeBag)
    }
}
