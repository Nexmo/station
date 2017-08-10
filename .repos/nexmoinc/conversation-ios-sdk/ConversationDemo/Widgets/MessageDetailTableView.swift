//
//  MessageDetailTableView.swift
//  ConversationDemo
//
//  Created by James Green on 20/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import NexmoConversation

public class MessageDetailTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    private var message: TextEvent?
    private var members = [Member]()
    
    // MARK:
    // MARK: Initializers

    /**
     Initialisation code when first constructed.
     */
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    public func initialise(with message: TextEvent?) {
        self.message = message
        
        if let message = message {
            members.append(contentsOf: message.distribution)
        }
        
        reloadData()
        
        /* Subscribe to receipt events. */
        message?.newReceiptRecord.addHandler { [weak self] _ in self?.reloadData() }
        message?.receiptRecordChanged.addHandler { [weak self] _ in self?.reloadData() }
    }
    
    // MARK:
    // MARK: Setup
    
    private func setup() {
        delegate = self
        dataSource = self
        
        separatorStyle = .none
    }

    // MARK:
    // MARK: UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count + 2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            /* Show the message bubble in row 0. */
            let reuseId = MessageBubbleView.getReuseId(message: message!)
            
            /* Allocate the cell either by recycling or from new, and set the contents. */
            var cell: MessageBubbleView? = tableView.dequeueReusableCell(withIdentifier: reuseId) as! MessageBubbleView?
            
            if cell == nil {
                cell = MessageBubbleView.Factory(onLeft: false, message: message!, parentWidth: self.superview!.frame.width, avatarEnabled: false, name: nil)
            } else {
                cell!.updateMessage(onLeft: false, message: message!, name: nil)
            }
            
            return cell!
        } else if indexPath.row == 1 {
            let cell: ReceiptDetailView? = tableView.dequeueReusableCell(withIdentifier: "ReceiptDetailView") as! ReceiptDetailView?
            cell!.MemberName.text = "Member"
            cell!.DeliveredDate.text = "Delivered"
            cell!.SeenDate.text = "Seen"
            
            return cell!
        } else {
            let cell: ReceiptDetailView? = tableView.dequeueReusableCell(withIdentifier: "ReceiptDetailView") as! ReceiptDetailView?
            let member = members[indexPath.row - 2]
            
            let receipt = self.message!.receiptForMember(member: member)
            cell!.update(member, with: receipt)
            
            return cell!
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            /* Calculate the height. */
            let height: CGFloat = MessageBubbleView.cellHeightForMessage(message: message!, parentWidth: self.superview!.frame.width, avatarEnabled: false, showName: false)
            return height
        } else {
            return 32
        }
    }
}
