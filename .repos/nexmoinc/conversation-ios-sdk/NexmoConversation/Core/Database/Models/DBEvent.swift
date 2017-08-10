//
//  DBEvent.swift
//  NexmoConversation
//
//  Created by James Green on 06/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import GRDB
import Gloss

internal class DBEvent: Record {

    /// Event model
    internal var rest: Event
    
    private var _type: Event.EventType?
    private var _text: String? // Any message text that was extracted from the body. It is extracted so that it can be easily searched if that became a requirement in the future.
    private var textHasBeenProcessed = false // Used to determine if we need to calculate _text, or if that has already been done.
    private var _body: String?
    
    internal var payload: Data? // Convenience property to be used by specific EventXYZ subclasses to store their own data. Eg. ImageEvent can use it to store the thumbnail.
    
    /// Used to mark messages that are being sent
    internal var isDraft: Bool
    
    /// Used to connect up draft and sent message.
    internal var draftSentCounterpart: Int32?
    
    /// List of member uuids
    internal var distribution: [String]
    
    internal var markedAsSeen: Bool
    
    internal var id: Int32 {
        get {
            return rest.id
        }
        set {
            rest.id = newValue
        }
    }
    
    internal var from: String? { return rest.from }
    
    internal var timestamp: Date { return rest.timestamp }
    
    internal var type: Event.EventType { return rest.type }
    
    internal var text: String? {
        get {
            if !textHasBeenProcessed {
                _text = body["text"] as? String
                textHasBeenProcessed = true
            }
            
            return _text
        }
        set {
            _text = newValue
            textHasBeenProcessed = true
        }
    }
    
    internal var body: JSON {
        if rest.body == nil {
            let jsonData: Data = _body!.data(using: String.Encoding.utf8)!
            
            rest.body = ((try? JSONSerialization.jsonObject(with: jsonData, options: [])) as! JSON)
        }
        
        return rest.body!
    }
    
    //TODO: body should be data type BLOB so would remove need to convert to string
    internal var bodyAsString: String {
        if _body == nil {
            if let restBody = rest.body, let jsonData = try? JSONSerialization.data(withJSONObject: restBody, options: .prettyPrinted), let converted = String(data: jsonData, encoding: .utf8) {
                _body = converted
            }
        }
        
        return _body ?? ""
    }
    
    internal var cid: String { return rest.cid }
    
    // MARK:
    // MARK: Initializers
    
    internal init(conversationUuid: String, event: Event, seen: Bool) {
        rest = event
        isDraft = false
        distribution = []
        markedAsSeen = seen
        
        super.init()
    }
    
    internal init(conversationUuid: String, type: Event.EventType, memberId: String, seen: Bool) {
        rest = Event(cid: conversationUuid, type: type, memberId: memberId)
        rest.body = [:]
        isDraft = false
        distribution = []
        markedAsSeen = seen
        
        super.init()
    }

    required init(row: Row) {
        let type = Event.EventType.fromInt32(row.value(named: "type"))!
        
        _type = type
        _text = row.value(named: "text")
        textHasBeenProcessed = true
        _body = row.value(named: "body")
        payload = row.value(named: "payload")
        isDraft = row.value(named: "isDraft")
        draftSentCounterpart = row.value(named: "draftSentCounterpart")
        distribution = ((row.value(named: "distribution") as DatabaseCoder).object as! NSArray).map { $0 as! String }
        markedAsSeen = row.value(named: "markedAsSeen")

        rest = Event(cid: row.value(named: "cid"),
                     id: row.value(named: "eventId"),
                     from: row.value(named: "from"),
                     to: nil,
                     timestamp: row.value(named: "timestamp"),
                     type: type)
        
        super.init(row: row)
    }
    
    // MARK:
    // MARK: Name
    
    override class var databaseTableName: String {
        return "events"
    }
    
    // MARK:
    // MARK: Structure
    
    override var persistentDictionary: [String : DatabaseValueConvertible?] {
        return ["cid": rest.cid,
                "eventId": rest.id,
                "from": rest.from,
                "timestamp": rest.timestamp,
                "type": type.toInt32,
                "text": text,
                "body": bodyAsString,
                "payload": payload,
                "isDraft": isDraft,
                "draftSentCounterpart": draftSentCounterpart,
                "distribution": DatabaseCoder(distribution as NSArray),
                "markedAsSeen": markedAsSeen
        ]
    }
}
