//
//  ConversationManageMembersListWidget.swift
//  NexmoConversation
//
//  Created by James Green on 28/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import NexmoConversation

public class ConversationManageMembersListWidget: UITableView, UITableViewDelegate, UITableViewDataSource {

    private(set) var conversation: Conversation?
    private var members: NexmoConversation.LazyCollection<Member>?

    // MARK:
    // MARK: Initialise

    public override func awakeFromNib() {
        super.awakeFromNib()
        
        delegate = self
        dataSource = self
    }

    public func initialise(conversation: Conversation?) {
        self.conversation = conversation
        self.members = conversation?.members
        
        self.conversation?.membersChanged.addHandler {
            self.members = conversation?.members
            
            self.reloadData()
        }
    }

    // MARK:
    // MARK: Setup

    private func setup() {

    }

    // MARK:
    // MARK: UITableViewDataSource

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.members != nil {
            return self.members!.count
        } else {
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MemberListCellWidget? = tableView.dequeueReusableCell(withIdentifier: "MemberListCellWidget") as! MemberListCellWidget?
        
        let member = members![indexPath.row]
        cell?.setMember(member: member)
        
        return cell!
    }

    // MARK:
    // MARK: UITableViewDelegate

    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var result = [UITableViewRowAction]()

        /* Leave. */
        let leave = UITableViewRowAction(style: .normal, title: "Remove", handler: { (_, indexPath) -> Void in
            let member = self.members![indexPath.row]
            
            _ = member.kick().subscribe(onSuccess: { [weak self] in
                self?.reloadData()
            })
        })
        
        leave.backgroundColor = UIColor.red
        result.append(leave)
        
        return result
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let member = members![indexPath.row]
        return member.state != .left
    }
}
