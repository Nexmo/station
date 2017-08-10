//
//  MessagesListView.swift
//  NexmoChat
//
//  Created by Jonathan Tilley on 28/04/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import NexmoConversation

public class MessagesTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    let avatarEnabled = true

    public var delegateConversationView: ConversationViewDelegate?
    private(set) var conversation: Conversation?

    /// A list of all messages with the same indexing as indexPath
    private var messages: [EventBase] = []

    // MARK:
    // MARK: Initializers

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        delegate = self
        dataSource = self
        separatorStyle = .none
        keyboardDismissMode = .onDrag
    }
    
    public func initialise(conversation: Conversation) {
        self.conversation = conversation
        
        setup()
    }
    
    // MARK:
    // MARK: Setup
    
    private func setup() {
        /* Display the current messages and scroll to the most recent. */
        guard let conversation = conversation else { return }
        
        messages.removeAll(keepingCapacity: true)
        messages.append(contentsOf: conversation.allEvents.filter { $0 is TextEvent || $0 is ImageEvent })
        
        reloadData()
        
        bindUI()
    }
    
    private func bindUI() {
        /* Attach to events. */
        conversation?.newEventReceived.addHandler { [weak self] _ in
            DispatchQueue.main.async { self?.resetDataSource() }
        }
        
        conversation?.events.addHandler { [weak self] (_, type) in
            switch type {
            case .reset: break
            case .inserts(_): break
            case .deletes(_): self?.resetDataSource()
            case .updates(_): break
            case .move(_, _): break
            case .beginBatchEditing: break
            case .endBatchEditing: break
            }
        }
    }
    
    // MARK:
    // MARK: DataSource
    
    private func resetDataSource() {
        guard let conversation = conversation else { return }
        
        messages = conversation.allEvents.filter { $0 is TextEvent || $0 is ImageEvent }
        
        DispatchQueue.main.async {
            self.reloadData()
            self.scrollToLastMessage(animation: .fade)
        }
    }
    
    // MARK:
    // MARK: UITableViewDataSource

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messageForRowAtIndexPath(indexPath: indexPath)
        
        /* Determine various details. */
        let reuseId = MessageBubbleView.getReuseId(message: message)
        let name = nameForRowAtIndexPath(indexPath: indexPath)
        let fromOurselves = message.from.isMe
        
        /* Allocate the cell either by recycling or from new, and set the contents. */
        var cell: MessageBubbleView? = tableView.dequeueReusableCell(withIdentifier: reuseId) as! MessageBubbleView?
        
        if cell == nil {
            cell = MessageBubbleView.Factory(onLeft: !fromOurselves, message: message, parentWidth: self.superview!.frame.width, avatarEnabled: avatarEnabled, name: name)
        } else {
            cell!.updateMessage(onLeft: !fromOurselves, message: message, name: name)
        }
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clearSelection()
        
        let message = messageForRowAtIndexPath(indexPath: indexPath)
        
        delegateConversationView?.onShowMessageDetail(message: message)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = messageForRowAtIndexPath(indexPath: indexPath)
        let name = nameForRowAtIndexPath(indexPath: indexPath)
        
        /* Calculate the height. */
        let height = MessageBubbleView.cellHeightForMessage(
            message: message, 
            parentWidth: self.superview!.frame.width, 
            avatarEnabled: avatarEnabled,
            showName: (name != nil)
        )
        
        return height
    }
    
    // MARK:
    // MARK: DataSource
    
    /**
     Helper to get the message for a given row.
     
     - parameter indexPath: index path of the required message
     
     - returns: The message, or nil if not available.
     */
    private func messageForRowAtIndexPath(indexPath: IndexPath) -> TextEvent {
        return messages[indexPath.row] as! TextEvent
    }
    
    /**
     Determine whether this cell should show the name. It should show the name if the previous message was not from the same sender, and is not us.
     
     - parameter indexPath: indexPath
     
     - returns: The name as a string, or nil if no name is to be shown.
     */
    private func nameForRowAtIndexPath(indexPath: IndexPath) -> String? {
        let message = messageForRowAtIndexPath(indexPath: indexPath)
        
        /* Return nil if the message is from us or its there very first message */
        if message.from.isMe || indexPath.row == 0 {
            return nil
        }
        
        /* See if message is from same sender as previous. */
        let previousMessage = messageForRowAtIndexPath(indexPath: IndexPath(row:(indexPath.row - 1), section:indexPath.section))
        var showName: Bool
        
        if indexPath.row == 0 {
            showName = true
        } else {
            showName = (message.from != previousMessage.from)
        }
        
        /* Determine the name. */
        var name: String? = nil
        
        if showName {
            name = message.from.displayName
        }
        
        return name
    }
    
    // MARK:
    // MARK: Layout
    
    internal func scrollToLastMessage(animation: UITableViewRowAnimation) {
        guard !messages.isEmpty, !visibleCells.isEmpty else { return }
        
        let indexPathOfLastRow = IndexPath(row: (messages.count - 1), section: 0)
            
        guard cellForRow(at: indexPathOfLastRow) != nil else { return }
            
        scrollToRow(at: indexPathOfLastRow, at: .bottom, animated: false)
    }
    
    // MARK:
    // MARK: Helper
    
    /**
     Helper to clear any selected row in the table.
     */
    private func clearSelection() {
        if self.indexPathForSelectedRow != nil {
            self.deselectRow(at: self.indexPathForSelectedRow!, animated: false)
        }
    }
}
