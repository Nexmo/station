//
//  LogTest.swift
//  NexmoConversation
//
//  Created by shams ahmed on 10/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class LogTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        
        it("prints a warm log") {
            Log.warn(.other, "test")
            Log.warn(.rest, "test")
        }
        
        it("prints a info log") {
            Log.info(.other, "test")
            Log.info(.rest, "test")
        }
        
        it("prints a error log") {
            Log.error(.other, "test")
            Log.error(.rest, "test")
        }

        it("fails to print none") {
            ConversationClient.configuration = Configuration(with: Configuration.LogLevel.none)

            Log.info(.other, "")
        }

        it("fails to print info") {
            ConversationClient.configuration = Configuration(with: Configuration.LogLevel.info)

            Log.info(.other, "")
        }

        it("fails to print warning") {
            ConversationClient.configuration = Configuration(with: Configuration.LogLevel.error)

            Log.warn(.other, "")
        }

        it("fails to print error") {
            ConversationClient.configuration = Configuration(with: Configuration.LogLevel.info)

            Log.error(.other, "")
        }
    }
}
