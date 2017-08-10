//
//  TestConstants.swift
//  NexmoConversation
//
//  Created by Ivan Ivanov on 22/03/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

/// Common constants used in tests
struct TestConstants {
    
    /// Current application user
    struct User {
        static let uuid = "USR-sdk-test"
        static let name = "capi-test-sdk@nexmo.com"
    }
    
    /// Another user
    struct PeerUser {
        static let uuid = "my-friends-user-id"
        static let name = "my-friends-name"
    }
    
    /// Current member id
    struct Member {
        static let uuid = "MEM-sdk-test"
    }
    
    /// Peer member id
    struct PeerMember {
        static let uuid = "my-friends-member-id"
    }
    
    /// Test conversation id and name
    struct Conversation {
        static let uuid = "CON-sdk-test"
        static let name = "CON-sdk-test"
    }
    
    /// Test text id and text
    struct Text {
        static let uuid = 4
        static let text = "Hey, anybody out there?"
    }
    
    /// Test image id
    struct Image {
        static let uuid = 4
    }
}
