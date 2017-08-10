//
//  ConversationListViewController.swift
//  NexmoChat
//
//  Created by James Green on 26/05/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import NexmoConversation

/**
 This View Controller shows a list of conversations, and allows a new conversation to be created.
 Most of the heavy lifting is done in the ConversationListWidget() widget, with the code in this
 file being fairly minimal. This allows developers to more easily use ConversationListWidget()
 in their own View Controllers, should they wish.
 
 Importantly, this View Controller does ensure that the Session is logged in so that other
 widgets can just assume a valid connection.
 */
public class ConversationListViewController: UIViewController, ConversationListDelegate, PresentAlert {
    
    @IBOutlet private weak var conversationListWidget: ConversationListWidget!
    
    // MARK:
    // MARK: Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    
        setup()
        bindUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        clearSelection()
    }
    
    // MARK:
    // MARK: Setup()
    
    private func setup() {
        conversationListWidget.delegateConversationList = self
        
        navigationController?.navigationBar.topItem?.title = ""

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        appDelegate.client.state.asDriver().debug().asObservable().subscribe().addDisposableTo(appDelegate.client.disposeBag)
    }
    
    private func bindUI() {
        ConversationClient.instance.state.asDriver().asObservable().skip(1).subscribe(onNext: { state in
            // if disconnected and no token, pop to login 
            if state == .disconnected && ConversationClient.instance.account.token == nil {
                self.loginScreen()
            }
        }).addDisposableTo(ConversationClient.instance.disposeBag)
        
        ConversationClient.instance.conversation.conversations.asObservable.subscribe(onNext: { [weak self] change in
            switch change {
            case .inserted(let conversations, let reason):
                switch reason {
                case .new: break
                case .invitedBy(let member):
                    self?.presentAlert(
                        title: "New invitation",
                        message: "\(member.user.displayName.isEmpty ? member.user.name : member.user.displayName) would like you to join \(conversations.first?.name ?? "Unknown")",
                        actionTitle: "Join",
                        { _ in self?.joinConversation(conversations[0]) }
                    )
                }
            case .updated: break
            case .deleted: break
            }

            self?.conversationListWidget.refresh()
        }).addDisposableTo(ConversationClient.instance.disposeBag)
    }

    // MARK:
    // MARK: Navigation
    
    private func loginScreen() {
        let storyboard = UIStoryboard.storyboard(.main)
        let viewController: LoginViewController = storyboard.instantiateViewController()
        
        navigationController?.setViewControllers([viewController], animated: true)
    }

    // MARK:
    // MARK: TableView

    /**
     Helper to clear any selected row in the table.
     */
    private func clearSelection() {
        guard let indexPath = conversationListWidget.indexPathForSelectedRow else { return }
        
        conversationListWidget.deselectRow(at: indexPath, animated: false)
        conversationListWidget.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // MARK:
    // MARK: Storyboard
    
    /**
     Pass information to the incoming view controller.
     
     - parameter segue:  segue
     - parameter sender: sender
     */
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConversationViewController" {
            let viewController = segue.destination as? ConversationViewController
            guard let conversation: Conversation = sender as? Conversation else { return }
            
            viewController?.initialise(conversation: conversation)
        }
    }
    
    // MARK:
    // MARK: Private - Navigation
    
    /**
     Helper to go to a new screen to show the given conversation.
     
     - parameter conversation: The conversation
     */
    private func goToConversationScreen(conversation: Conversation) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        performSegue(withIdentifier: "ConversationViewController", sender: conversation)
    }
    
    // MARK:
    // MARK: IBAction
    
    @IBAction private func createConversationPressed(_ sender: AnyObject) {
        askForConversationName()
    }
    
    // MARK:
    // MARK: Alert
    
    private func askForConversationName() {
        let alert = UIAlertController(title: "New Conversation", message: "Please enter the title for the new conversation", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            let nameField = alert.textFields![0] as UITextField
            
            self.createConversation(with: nameField.text)
        }))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Name"
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    private func showConversationError() {
        let errorAlert = UIAlertController(title: "Error", message: "Failed to create a conversation", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(errorAlert, animated: true)
    }
    
    // MARK:
    // MARK: Conversation
    
    /**
     ConversationListDelegate - Handle a conversation being selected.
     
     - parameter conversation: The selected conversation.
     */
    public func onConversationSelected(conversation: Conversation) {
        /* See if we've left the conversation. */
        if conversation.state == .left {
            /* We have left this conversation, so can't enter it. */
            let alert = UIAlertController(title: conversation.uuid, message: "You have left this conversation, so can't view the messages.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true)
            
            clearSelection()
            
            /* See if we need to join the conversation. */
        } else if conversation.state == .invited {
            /* Ask the user if they want to join. */
            let alert = UIAlertController(title: "Accept Invite?", message: "Do you wish to join this conversation?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Join", style: .default, handler: { _ in self.joinConversation(conversation) }))
            
            alert.addAction(UIAlertAction(title: "Decline", style: .default, handler: { _ in
                _ = conversation.leave().subscribe(onSuccess: { [weak self] in
                    self?.conversationListWidget.refresh()
                    self?.clearSelection()
                })
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            clearSelection()
        } else {
            /* Go straight to conversation screen. */
            goToConversationScreen(conversation: conversation)
        }
    }
    
    @discardableResult
    private func createConversation(with name: String?) -> Bool {
        let client = ConversationClient.instance
        let model = ConversationController.CreateConversation(name: name ?? "")

        client.conversation.new(model, withJoin: true).subscribe(onError: { [weak self] _ in
            self?.showConversationError()
        }).addDisposableTo(client.disposeBag)
        
        return true
    }

    internal func joinConversation(_ conversation: Conversation) {
        conversation.join().subscribe(onSuccess: { [weak self] in
            self?.conversationListWidget.refresh()
            self?.goToConversationScreen(conversation: conversation)
        }, onError: { [weak self] error in
            self?.presentAlert(
                title: "Failed to join conversation: \(conversation.uuid)",
                message: error.localizedDescription,
                actionTitle: nil, nil
            )

            self?.conversationListWidget.refresh()
        }).addDisposableTo(ConversationClient.instance.disposeBag)
    }
}
