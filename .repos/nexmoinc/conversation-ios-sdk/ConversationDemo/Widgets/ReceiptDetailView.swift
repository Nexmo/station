//
//  ReceiptDetailView.swift
//  ConversationDemo
//
//  Created by James Green on 20/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import NexmoConversation

public class ReceiptDetailView: UITableViewCell {
    
    @IBOutlet weak var MemberName: UILabel!
    @IBOutlet weak var DeliveredDate: UILabel!
    @IBOutlet weak var SeenDate: UILabel!
    
    // MARK:
    // MARK: Update
    
    public func update(_ member: Member, with receipt: ReceiptRecord?) {
        MemberName.text = member.user.name
        
        if let receipt = receipt {
            DeliveredDate.text = DateHelper.prettyPrint(receipt.date)
            SeenDate.text = DateHelper.prettyPrint(receipt.date)
        } else {
            DeliveredDate.text = ""
            SeenDate.text = ""
        }
    }
}
