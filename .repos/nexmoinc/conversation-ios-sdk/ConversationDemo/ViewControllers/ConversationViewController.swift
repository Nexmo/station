//
//  DisplayConversationViewController.swift
//  Nexmo
//
//  Created by Jonathan Tilley on 12/04/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import NexmoConversation

public class ConversationViewController: UIViewController, MessageComposeDelegate, MessagesNavBarDelegate, ConversationViewDelegate {
    @IBOutlet private weak var tableMinimumHeight: NSLayoutConstraint!
    @IBOutlet private weak var bottomOfScreenPadding: NSLayoutConstraint!
    @IBOutlet private weak var MessagesTable: MessagesTableView!
    @IBOutlet private weak var messageComposer: MessageComposeWidget!
    @IBOutlet private weak var conversationAssistWidget: ConversationAssistWidget!
    @IBOutlet weak var navBarTitleWidget: MessagesNavBar!
    
    private var conversation: Conversation? {
        didSet {
            // Side-effect since view controller is created via storyboard making DI impossible
            self.viewModel.conversation = conversation
        }
    }

    private var viewModel: ConversationViewModel = ConversationViewModel()
    
    // MARK:
    // MARK: Initializers
    
    /**
     Called after we have been loaded, but before we appear, ie. usually from prepareForSegue() of the parent.
     
     - parameter conversation: The conversation to show.
     */
    public func initialise(conversation: Conversation) {
        self.conversation = conversation
    }
    
    // MARK:
    // MARK: Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        /* Remove back button text */
        self.navigationController?.navigationBar.topItem?.title = ""
        
        /* Init children. */
        messageComposer.delegate = self
        navBarTitleWidget.delegate = self
        MessagesTable.delegateConversationView = self
        navBarTitleWidget.refresh()
     
        bindUI()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /* Subscribe to keyboard events. */
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        /* Set our appearance. */
        navigationItem.title = conversation?.name
        
        /* Set up children. */
        MessagesTable.initialise(conversation: conversation!)
        conversationAssistWidget.initialise(conversation: conversation!)
        navBarTitleWidget.initialise(conversation: conversation!)
        messageComposer.initialise(conversation: conversation!)
        
        navBarTitleWidget.refresh()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        MessagesTable.scrollToLastMessage(animation: .bottom)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        /* Unsubscribe from keyboard events. */
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        /* Are we being permanently closed, if so free resources. */
        if isBeingDismissed || isMovingFromParentViewController {
            //            /* Unsubscribe from conversation events. */
            //            Session.instance.client.removeConversationDelegate(self)
            
            /* Inform children. */
            conversationAssistWidget.close()
            messageComposer.close()
        }
    }
    
    // MARK:
    // MARK: Binding
    
    private func bindUI() {
        viewModel.conversation?.memberLeft.addHandler { [weak self] member in
            guard member.user.isMe else { return }
            
            self?.userKickedOut()
        }
        
        viewModel.conversation?.memberJoined.addHandler { [weak self] _ in self?.navBarTitleWidget.refresh() }
    }
    
    // MARK:
    // MARK: Callback
    
    private func userKickedOut() {
        _ = navigationController?.popToRootViewController(animated: true)
        
        let alert = UIAlertController(
            title: "Error",
            message: "You have been kicked out of this conversation",
            preferredStyle: .alert)
            
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            
        present(alert, animated: true)
    }
    
    // MARK:
    // MARK: Options
    
    private func displayOptions(for event: TextEvent) {
        let alert = UIAlertController(
            title: "Select an option",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "More Details", style: .default, handler: { _ in
           self.performSegue(withIdentifier: String(describing: MessageDetailsViewController.self), sender: event)
        }))
        
        if event.from.isMe {
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self.conversation?.delete(event)
            }))
        }
    
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in
            self.dismiss(animated: true)
        }))
        
        present(alert, animated: true)
    }

    // MARK:
    // MARK: Keyboard
    
    public func keyboardWillChangeFrame(notification: NSNotification) {
        /* Determine the size of the keyboard, and increase the size of our constraint at the bottom of the screen to make room for it. */
        let userInfo = notification.userInfo!
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).uint32Value << 16
        let animationCurve = UIViewAnimationOptions(rawValue: UInt(rawAnimationCurve))
        
        /* Update the bottom of screen constraint. */
        bottomOfScreenPadding.constant = view.bounds.maxY - convertedKeyboardEndFrame.minY        
        
        /* Animate. */
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.beginFromCurrentState, animationCurve], animations: {
            self.view.layoutIfNeeded()
            }, completion: { _ in
                /* Put the scrollview at the bottom. */
                self.MessagesTable.scrollToLastMessage(animation: .fade)
        })
    }
    
    // MARK:
    // MARK: MessageComposeDelegate
    
    public func onTextComposed(_ text: String) {
        viewModel.send(text)
    }
    
    public func onMessageImageComposed(_ image: UIImage) {
        viewModel.send(image)
    }
    
    // MARK:
    // MARK: MessagesNavBarDelegate
    
    public func onNavBarMembershipSelected() {
        performSegue(withIdentifier: "ConversationManageViewController", sender: self)
    }
    
    // MARK:
    // MARK: Segue
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConversationManageViewController" {
            let vc: ConversationManageViewController = segue.destination as! ConversationManageViewController
            vc.initialise(conversation: conversation!)
        } else if segue.identifier == "MessageDetailsViewController" {
            let vc: MessageDetailsViewController = segue.destination as! MessageDetailsViewController
            vc.initialise(message: sender as! TextEvent)
        }
    }
    
    public func onShowMessageDetail(message: TextEvent) {
        displayOptions(for: message)
    }
    
    /**
     MAuthorizationDelegate - Handle login failure.
     */
    public func conversationClient(conversationClient: ConversationClient, loginFailed error: NSError!) {
        /* For now, go back to the login screen. */
        let storyboard = UIStoryboard.storyboard(.main)
        let viewController: LoginViewController = storyboard.instantiateViewController()
        
        navigationController!.setViewControllers([viewController], animated: true)
    }
}
