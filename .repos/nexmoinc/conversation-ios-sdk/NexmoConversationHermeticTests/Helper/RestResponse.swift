//
//  RestResponse.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 26/05/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

internal protocol Response {
    var value: String { get }
}

/// Rest Response to get from Mocket IO
///
/// - changeStateGetInfoMembers: <#changeStateGetInfoMembers description#>
/// - createGetInfoConversations: <#createGetInfoConversations description#>
/// - createGetListUser: <#createGetListUser description#>
/// - getUserConversationList: <#getUserConversationList description#>
/// - getInfoSetInfoDeleteConversation: <#getInfoSetInfoDeleteConversation description#>
/// - getInfoUpdateStateDeleteMember: <#getInfoUpdateStateDeleteMember description#>
/// - registerDevice: <#registerDevice description#>
/// - sendGetRangeEvents: <#sendGetRangeEvents description#>
/// - setStatusGetDeleteEvent: <#setStatusGetDeleteEvent description#>
/// - updateGetDeleteUser: <#updateGetDeleteUser description#>
/// - updateUserPresence: <#updateUserPresence description#>
internal enum RestResponse: String, Response {
    case changeStateGetInfoMembers = "change_state_getinfo_members"
    case createGetInfoConversations = "create_getinfo_conversations"
    case createGetListUser = "create_getlist_user"
    case getUserConversationList = "get_user_conversation_list"
    case getInfoSetInfoDeleteConversation = "getinfo_setinfo_delete_conversation"
    case getInfoUpdateStateDeleteMember = "getinfo_update_state_delete_member"
    case registerDevice = "register_device"
    case sendGetRangeEvents = "send_getrange_events"
    case setStatusGetDeleteEvent = "setstatus_get_delete_event"
    case updateGetDeleteUser = "update_get_delete_user"
    case updateUserPresence = "update_user_presence"

    // MARK:
    // MARK: Response

    var value: String { return rawValue }
}
