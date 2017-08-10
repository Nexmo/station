//
//  ConversationListWidget.swift
//  NexmoChat
//
//  Created by James Green on 26/05/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import NexmoConversation

/**
 This widget shows a list of all conversation in a table. The superview/parent must
 call initialise() and close() to maintain the widget's lifecycle.
 */
public class ConversationListWidget: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private var conversations: ConversationCollection? // Has same ordering as indexPath
    internal var delegateConversationList: ConversationListDelegate?
    
    // MARK:
    // MARK: Initializers

    public override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }
    
    // MARK:
    // MARK: Setup
    
    private func setup() {
        delegate = self
        dataSource = self

        conversations = ConversationClient.instance.conversation.conversations
    }

    /**
     Refetch the list of conversations. Take it from the top again.
     */
    public func refresh() {
        // TODO - Make this a new animated insert rather than just a table refresh.
        conversations = ConversationClient.instance.conversation.conversations // Get the latest list.
        
        reloadData()
        scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }

    // MARK:
    // MARK: UITableViewDataSource

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* Prepare a cell to show this conversation. */
        let cell: ConversationListCellWidget? = tableView.dequeueReusableCell(withIdentifier: "ConversationListCellWidget") as! ConversationListCellWidget?
        
        let conversation = conversations![indexPath.row]
        cell?.conversation = conversation

        return cell!
    }

    // MARK:
    // MARK: UITableViewDelegate

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /* Tell our parent/delegate that a conversation has been selected. */
        if (delegateConversationList != nil) {
            let conversation = conversations![indexPath.row]
            delegateConversationList?.onConversationSelected(conversation: conversation)
        }
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        /* A row has been swiped, so show the appropriate options. */
        var result = [UITableViewRowAction]()
        
        /* Leave option. */
        let leave = UITableViewRowAction(style: .normal, title: "Leave", handler: { (_, indexPath: IndexPath!) -> Void in
            /* Issue leave. */
            let conversation = self.conversations![indexPath.row]
            
            _ = conversation.leave().subscribe(onSuccess: { [weak self] in
                self?.refresh()
            })
        })
        
        leave.backgroundColor = UIColor.red
        result.append(leave)
        
        return result
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        /* All rows can be edited, because they all provide the leave option. */
        return true
    }
}
