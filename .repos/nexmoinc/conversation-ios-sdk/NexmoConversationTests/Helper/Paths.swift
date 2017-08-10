//
//  Assets.swift
//  NexmoConversation
//
//  Created by shams ahmed on 29/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

/// List of all assets for testing
internal enum AssetsTest: String {
    
    case nexmo = "nexmo_logo"

    /// get path of asset
    ///
    /// - returns: path
    var path: String {
        switch self {
        case .nexmo: return self.rawValue+".jpeg"
        }
    }
}

/// List of all mock JSON responses
///
/// - uploadedImage: upload image response
/// - uploadedImageOther: upload image response 2
/// - sendImageMessage: response of event id for a image message
/// - uploadPushCertificate: push notification result
/// - uploadPushCertificates: push notifications result
/// - addDeviceToken: response of adding a new device token
/// - corruptedData: bad random data
/// - joinConversation: join conversation reponse
/// - demo1: user model
/// - demo2: another user model
/// - deleteEvent: response of delete event
/// - invitedMemberToAConversation: invite response of a suer joining a conversation
/// - events: list of events from a conversation
/// - memberJoinedEvent: event for member join action
/// - textEvent: event for text
/// - conversations: list of lite conversations
/// - liteConversation: small conversation response
/// - fullConversation: full conversation response
/// - invitedMemberToAConversation: invite user to a conversation response
/// - typingOffEvent: event sent to CAPI when users starts typing
/// - detailedMemberModel: detailed member model
/// - member: member model
/// - sessionSuccess: session success socket message
/// - fetchEventNotJoined: user not joined to conversation
/// - conversationNotFound: detailed conversation not found
/// - memberAlreadyJoinedError: trying to join an conversation while the member has already joined
/// - memberInvitedViaSocket: member invite with member details from the socket
/// - fullConversationMultipleInviteBy: full conversation with a multiple invite_by member
/// - fullConversationSingleInviteBy: full conversation with invite_by member
/// - memberWithMultipleTimestamps: Member object with multiple states for dates
internal enum JSONTest: String {
    case uploadedImage = "UploadedImage"
    case uploadedImageOther = "UploadedImageOther"
    case sendImageMessage = "SendImageMessage"
    case uploadPushCertificate = "Upload_Push_Certificate"
    case uploadPushCertificates = "Upload_Push_Certificates"
    case addDeviceToken
    case corruptedData
    case joinConversation
    case demo1
    case demo2
    case events
    case deleteEvent
    case invitedMemberToAConversation = "invitedMemberToAConversation2"
    case memberJoinedEvent = "event_member_joined"
    case textEvent = "event_text"
    case conversations
    case liteConversation
    case fullConversation
    case inviteUser = "invitedMemberToAConversation"
    case typingOffEvent
    case detailedMemberModel
    case member
    case sessionSuccess
    case errorNotFound
    case fetchEventNotJoined
    case conversationNotFound
    case memberAlreadyJoinedError
    case memberInvitedViaSocket
    case fullConversationMultipleInviteBy
    case fullConversationSingleInviteBy
    case memberWithMultipleTimestamps
}
