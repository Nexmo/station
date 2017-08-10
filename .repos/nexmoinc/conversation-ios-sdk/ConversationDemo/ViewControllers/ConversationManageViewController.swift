//
//  ConversationManageViewController.swift
//  NexmoConversation
//
//  Created by James Green on 28/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import UIKit
import NexmoConversation

public class ConversationManageViewController: UIViewController, UserSelectionDelegate {
    @IBOutlet private weak var conversationName: UITextField!
    @IBOutlet private weak var conversationAvatar: AvatarWidget!
    @IBOutlet private weak var charactersRemaining: UILabel!
    @IBOutlet private weak var userSelectionWidget: UserSelectionWidget!
    @IBOutlet private weak var membersTable: ConversationManageMembersListWidget!
    
    private var conversation: Conversation?
    
    public func initialise(conversation: Conversation) {
        self.conversation = conversation
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        /* Remove back button text */
        self.navigationController?.navigationBar.topItem?.title = ""
        
        /* Initialise widgets. */
        userSelectionWidget.delegate = self
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        conversationName.text = conversation?.name

        /* Initialise widgets. */
        membersTable.initialise(conversation: self.conversation)
    }
    
    public func onUserSelected(user: String) {
        conversation?.invite(user).subscribe(onError: { [weak self] _ in
            let errorAlert = UIAlertController(title: "Error", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))

            self?.present(errorAlert, animated: true)
        }).addDisposableTo(ConversationClient.instance.disposeBag)
    }
}
