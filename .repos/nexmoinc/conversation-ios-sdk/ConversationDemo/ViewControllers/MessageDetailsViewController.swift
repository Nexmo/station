//
//  MessageDetailsViewController.swift
//  ConversationDemo
//
//  Created by James Green on 20/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import UIKit
import NexmoConversation

public class MessageDetailsViewController: UIViewController {
    
    @IBOutlet private weak var Table: MessageDetailTableView!
    
    private var message: TextEvent?
    
    // MARK:
    // MARK: Initializers
    
    /**
     Called after we have been loaded, but before we appear, ie. usually from prepareForSegue() of the parent.
     
     - parameter conversation: The conversation to show.
     */
    public func initialise(message: TextEvent) {
        self.message = message
    }
    
    // MARK:
    // MARK: Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(String(describing: message))")
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Table.initialise(with: message)
    }
}
