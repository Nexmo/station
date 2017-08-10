//
//  QuickSpec+Listener.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 26/05/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble

extension QuickSpec {

    // MARK:
    // MARK: Setup

    open override func setUp() {
        super.setUp()

        setupListener()
    }

    // MARK:
    // MARK: Private - Helper

    private func setupListener() {
        // Start helper
        _ = ClientListener.default
    }
}
