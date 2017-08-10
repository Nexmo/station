//
//  MemberListCellWidget.swift
//  NexmoChat
//
//  Created by James Green on 08/06/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import NexmoConversation

public class MemberListCellWidget: UITableViewCell {
    
    // MARK:
    // MARK: Properties
    
    @IBOutlet weak var avatar: AvatarWidget!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK:
    // MARK: Member
    
    public func setMember(member: Member) {
        /* Set the name. */
        let name = member.user.name
        nameLabel.text = name

        /* Set the avatar. */
        avatar.user = member.user
        
        /* Set the state with an initial capitals string. */
        handleStateChanged(for: member, newState: member.state)
    }
    
    // MARK:
    // MARK: Observe
    
    internal func handleStateChanged(for member: Member, newState: MemberModel.State) {
        var state: String = newState.rawValue.lowercased()
        let first = String(state.characters.prefix(1)).uppercased()
        let other = String(state.characters.dropFirst())

        state = first + other

        if let date = member.date(of: member.state) {
            statusLabel.text = "\(state) on \(date)"
        } else {
            statusLabel.text = "\(state) on Unknown"
        }

    }
}
