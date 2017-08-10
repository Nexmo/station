//
//  MessagesNavBar.swift
//  NexmoChat
//
//  Created by James Green on 07/06/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import NexmoConversation

@IBDesignable public class MessagesNavBar: UIView, UITextViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var membershipLabel: UILabel!
    @IBOutlet weak var titleContainer: UIView!
    
    public weak var delegate: MessagesNavBarDelegate?
    
    private var conversation: Conversation?
    
    // keep a local copy of names for tracking..until we can ask SDK for a fresh copy of member list
    private var memberNames: String? {
        return conversation?.members
            .filter { $0.state == .joined }
            .map { $0.user.isMe ? "You" : $0.user.displayName }
            .joined(separator: ", ")
    }
    
    // MARK:
    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        inflateFromXib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        inflateFromXib()
    }
    
    public func initialise(conversation: Conversation) {
        self.conversation = conversation
        
        refresh()
    }

    // MARK:
    // MARK: Nib
    
    private func inflateFromXib() {
        /* Load Xib file. */
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MessagesNavBar", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        /* Set properties of top level view. */
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    // MARK:
    // MARK: View
    
    /*
     The following overrides whatever we are told and ensure we are always full width.
     */
    public override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            if superview != nil {
                var fillWidthFrame = newFrame
                fillWidthFrame.origin.x = 0
                fillWidthFrame.size.width = (superview?.frame.size.width)!
                
                super.frame = fillWidthFrame
            } else {
                super.frame = newFrame
            }
        }
    }
    
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        /* Only process clicks that are withing our container, and therefore let the back button and any other items be clicked. */
        return titleContainer.frame.contains(point)
    }
    
    // MARK:
    // MARK: Refresh

    func refresh() {
        titleLabel.text = conversation?.name
        membershipLabel.text = memberNames
    }
    
    // MARK:
    // MARK: Action
    
    @IBAction func handleTapped(_ sender: AnyObject) {
        delegate?.onNavBarMembershipSelected()
    }
}
