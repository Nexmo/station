//
//  SocketResponse.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 26/05/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/// Socker response to get from Mocket IO
///
/// - conversationEventsSuccess: <#conversationEventsSuccess description#>
/// - conversationGetSuccess: <#conversationGetSuccess description#>
/// - conversationInviteSuccess: <#conversationInviteSuccess description#>
/// - conversationJoinSuccess: <#conversationJoinSuccess description#>
/// - conversationMemberDeleteSuccess: <#conversationMemberDeleteSuccess description#>
/// - eventDeleteSuccess: <#eventDeleteSuccess description#>
/// - eventDelete: <#eventDelete description#>
/// - imageDeliveredSuccess: <#imageDeliveredSuccess description#>
/// - imageDelivered: <#imageDelivered description#>
/// - imageSeenSuccess: <#imageSeenSuccess description#>
/// - imageSeen: <#imageSeen description#>
/// - imageSuccess: <#imageSuccess description#>
/// - image: <#image description#>
/// - memberInvited: <#memberInvited description#>
/// - memberJoined: <#memberJoined description#>
/// - memberLeft: <#memberLeft description#>
/// - newConversationSuccess: <#newConversationSuccess description#>
/// - pushRegisterSuccess: <#pushRegisterSuccess description#>
/// - pushSubscribeSuccess: <#pushSubscribeSuccess description#>
/// - pushUnregisterSuccess: <#pushUnregisterSuccess description#>
/// - pushUnsubscribeSuccess: <#pushUnsubscribeSuccess description#>
/// - sessionLoggedOut: <#sessionLoggedOut description#>
/// - sessionSuccess: <#sessionSuccess description#>
/// - textDeliveredSuccess: <#textDeliveredSuccess description#>
/// - textDelivered: <#textDelivered description#>
/// - textSeenSuccess: <#textSeenSuccess description#>
/// - textSeen: <#textSeen description#>
/// - textSuccess: <#textSuccess description#>
/// - textTypingOffSuccess: <#textTypingOffSuccess description#>
/// - textTypingOff: <#textTypingOff description#>
/// - textTypingOnSuccess: <#textTypingOnSuccess description#>
/// - textTypingOn: <#textTypingOn description#>
/// - text: <#text description#>
/// - userConversationsSuccess: <#userConversationsSuccess description#>
/// - userGetSuccess: <#userGetSuccess description#>
internal enum SocketResponse: String, Response {
    case conversationEventsSuccess = "conversation_events_success"
    case conversationGetSuccess = "conversation_get_success"
    case conversationInviteSuccess = "conversation_invite_success"
    case conversationJoinSuccess = "conversation_join_success"
    case conversationMemberDeleteSuccess = "conversation_member_delete_success"
    case eventDeleteSuccess = "event_delete_success"
    case eventDelete = "event_delete"
    case imageDeliveredSuccess = "image_delivered_success"
    case imageDelivered = "image_delivered"
    case imageSeenSuccess = "image_seen_success"
    case imageSeen = "image_seen"
    case imageSuccess = "image_success"
    case image = "image"
    case memberInvited = "member_invited"
    case memberJoined = "member_joined"
    case memberLeft = "member_left"
    case newConversationSuccess = "new_conversation_success"
    case pushRegisterSuccess = "push_register_success"
    case pushSubscribeSuccess = "push_subscribe_success"
    case pushUnregisterSuccess = "push_unregister_success"
    case pushUnsubscribeSuccess = "push_unsubscribe_success"
    case sessionLoggedOut = "session_logged-out"
    case sessionSuccess = "session_success"
    case textDeliveredSuccess = "text_delivered_success"
    case textDelivered = "text_delivered"
    case textSeenSuccess = "text_seen_success"
    case textSeen = "text_seen"
    case textSuccess = "text_success"
    case textTypingOffSuccess = "text_typing_off_success"
    case textTypingOff = "text_typing_off"
    case textTypingOnSuccess = "text_typing_on_success"
    case textTypingOn = "text_typing_on"
    case text = "text"
    case userConversationsSuccess = "user_conversations_success"
    case userGetSuccess = "user_get_success"

    // MARK:
    // MARK: Response

    var value: String { return rawValue }
}
