//
//  ConfigurationTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 30/05/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class ConfigurationTest: QuickSpec {

    // MARK:
    // MARK: Test

    override func spec() {
        it("compares logs using default configuration") {
            let configuration = Configuration.default

            let warning = configuration.logLevel >= Configuration.LogLevel.warning
            let error = configuration.logLevel >= Configuration.LogLevel.error
            let info = configuration.logLevel >= Configuration.LogLevel.info
            let none = configuration.logLevel >= Configuration.LogLevel.none

            expect(warning) == true
            expect(error) == true
            expect(info) == false
            expect(none) == false
        }

        it("compares logs using configuration with none") {
            let configuration = Configuration(with: Configuration.LogLevel.none)

            let warning = configuration.logLevel >= Configuration.LogLevel.warning
            let error = configuration.logLevel >= Configuration.LogLevel.error
            let info = configuration.logLevel >= Configuration.LogLevel.info
            let none = configuration.logLevel >= Configuration.LogLevel.none

            expect(warning) == false
            expect(error) == false
            expect(info) == false
            expect(none) == true
        }

        it("compares logs using configuration with info") {
            let configuration = Configuration(with: Configuration.LogLevel.info)

            let warning = configuration.logLevel >= Configuration.LogLevel.warning
            let error = configuration.logLevel >= Configuration.LogLevel.error
            let info = configuration.logLevel >= Configuration.LogLevel.info
            let none = configuration.logLevel >= Configuration.LogLevel.none

            expect(warning) == false
            expect(error) == false
            expect(info) == true
            expect(none) == false
        }

        it("compares logs using configuration with warning") {
            let configuration = Configuration(with: Configuration.LogLevel.warning)

            let warning = configuration.logLevel >= Configuration.LogLevel.warning
            let error = configuration.logLevel >= Configuration.LogLevel.error
            let info = configuration.logLevel >= Configuration.LogLevel.info
            let none = configuration.logLevel >= Configuration.LogLevel.none

            expect(warning) == true
            expect(error) == true
            expect(info) == false
            expect(none) == false
        }

        it("compares logs using configuration with error") {
            let configuration = Configuration(with: Configuration.LogLevel.error)

            let warning = configuration.logLevel >= Configuration.LogLevel.warning
            let error = configuration.logLevel >= Configuration.LogLevel.error
            let info = configuration.logLevel >= Configuration.LogLevel.info
            let none = configuration.logLevel >= Configuration.LogLevel.none

            expect(warning) == false
            expect(error) == true
            expect(info) == false
            expect(none) == false
        }
    }
}
