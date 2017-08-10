//
//  NetworkError+Code.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 28/06/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/// Known network error codes
internal extension NetworkError {

    // MARK:
    // MARK: Error

    /// Error code
    internal struct Code {

        // MARK:
        // MARK: Session

        /// Session code
        internal enum Session: String {
            case invalid = "session:invalid"
            case terminated = "session:terminated"
            case internalError = "session:error:internal"
            case invalidError = "session:error:invalid"
            case invalidEvent = "session:error:invalid-event"
            case notFound = "session:error:not-found"
        }

        // MARK:
        // MARK: Application

        /// Application code
        internal enum Application: String {
            case `internal` = "application:error:internal"
            case invalidEvent = "application:error:invalid-event"
        }

        // MARK:
        // MARK: Audio

        /// Audio code
        internal enum Audio: String {
            case invalidEvent = "audio:error:invalid-event"
            case notFound = "audio:error:not-found"
        }

        // MARK:
        // MARK: Conversation

        /// Conversation code
        internal enum Conversation: String {
            case alreadyAMember = "conversation:error:already-member"
            case alreadyJoined = "conversation:error:member-already-joined"
            case database = "conversation:error:db"
            case delete = "conversation:error:delete"
            case deleted = "conversation:error:deleted"
            case duplicateName = "conversation:error:duplicate-name"
            case `internal` = "conversation:error:internal"
            case internalMedia = "conversation:error:internal-media"
            case invalidAction = "conversation:error:invalid-action"
            case invalidChannel = "conversation:error:invalid-channel"
            case invalidEvent = "conversation:error:invalid-event"
            case invalidMemberState = "conversation:error:invalid-member-state"
            case notFound = "conversation:error:not-found"
        }

        // MARK:
        // MARK: Device

        /// Device code
        internal enum Device: String {
            case invalid = "device:error:invalid"
            case invalidEvent = "device:error:invalid-event"
        }

        // MARK:
        // MARK: Internal

        /// Internal code
        internal enum `internal`: String {
            case response = "error:internal-error-response"
            case invalidRequest = "error:invalid-request"
            case invalidResponse = "error:invalid-response"
        }

        // MARK:
        // MARK: Event

        /// Event code
        internal enum Event: String {
            case error = "event:error"
            case `internal` = "event:error:internal"
            case notFound = "event:error:not-found"
            case notJoined = "event:error:not-joined"
            case permissionDenied = "event:error:permission-denied"
            case unknownEvent = "event:error:unknown-event"
        }

        // MARK:
        // MARK: HTTP

        /// HTTP code
        internal enum HTTP: String {
            case `internal` = "http:error:internal"
            case methodNotAllowed = "http:error:method-not-allowed"
            case notFound = "http:error:not-found"
            case unsupportedMediaType = "http:error:unsupported-media-type"
            case validationFail = "http:error:validation-fail"
            case versionNotAllowed = "http:error:version-not-allowed"
        }

        // MARK:
        // MARK: IPS

        /// IPS code
        internal enum IPS: String {
            case invalidMember = "image:error:invalid-member"
            case notJoined = "image:error:not-joined"
            case permissionDenied = "image:error:permission-denied"
            case unknownEvent = "image:error:unknown-event"
        }

        // MARK:
        // MARK: Knocking

        /// Knocking code
        internal enum Knocking: String {
            case invalid = "knocking:error:invalid"
            case notFound = "knocking:error:not-found"
        }

        // MARK:
        // MARK: Leg

        internal enum Leg: String {
            case complete = "leg:error:complete"
            case database = "leg:error:db"
            case `internal` = "leg:error:internal"
            case invalidAction = "leg:error:invalid-action"
            case invalidApplication = "leg:error:invalid-application"
            case invalidEvent = "leg:error:invalid-event"
            case notAnswered = "leg:error:not-answered"
            case notFound = "leg:error:not-found"
        }

        // MARK:
        // MARK: Media

        /// Media code
        internal enum Media: String {
            case `internal` = "media:error:internal"
            case notFound = "media:error:not-found"
        }

        // MARK:
        // MARK: Mixer

        /// Mixer code
        internal enum Mixer: String {
            case `internal` = "mixer:error:internal"
            case notFound = "mixer:error:not-found"
        }

        // MARK:
        // MARK: Push

        /// Push code
        internal enum Push: String {
            case register = "push:register:error"
            case unregister = "push:unregister:error"
        }

        // MARK:
        // MARK: Recording

        /// Recording code
        internal enum Recording: String {
            case `internal` = "recording:error:internal"
            case notFound = "recording:error:not-found"
        }

        // MARK:
        // MARK: RTC

        /// RTC code
        internal enum RTC: String {
            case invalidEvent = "rtc:error:invalid-event"
            case notJoined = "rtc:error:not-joined"
            case permissionDenied = "rtc:error:permission-denied"
            case new = "rtc:new:error"
            case terminate = "rtc:terminate:error"
        }

        // MARK:
        // MARK: System

        /// System code
        internal enum System: String {
            case `internal` = "system:error:internal"
            case invalidEvent = "system:error:invalid-event"
            case invalidToken = "system:error:invalid-token"
            case permission = "system:error:permission"
            case unique = "system:error:unique"

        }

        // MARK:
        // MARK: Text

        /// Text code
        internal enum Text: String {
            case invalidMember = "text:error:invalid-member"
            case notJoined = "text:error:not-joined"
            case permissionDenied = "text:error:permission-denied"
            case unknownEvent = "text:error:unknown-event"
        }

        // MARK:
        // MARK: User

        /// User code
        internal enum User: String {
            case conversations = "user:conversations:error"
            case duplicateName = "user:error:duplicate-name"
            case `internal` = "user:error:internal"
            case invalidApplication = "user:error:invalid-application"
            case invalidEvent = "user:error:invalid-event"
            case notFound = "user:error:not-found"
            case getError = "user:get:error"
        }
    }
}
