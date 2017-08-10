//
//  ConversationAssistWidget.swift
//  NexmoChat
//
//  Created by James Green on 02/06/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import NexmoConversation

@IBDesignable public class ConversationAssistWidget: UIView {
    public static let TIMEOUT: TimeInterval = 3.0

    @IBOutlet weak var message: UILabel!
    
    private var blurredBackground: UIToolbar?
    private(set) var conversation: Conversation?
    private(set) var active = false
    private var disappearTimer: Timer?
    
    private var whoIsTyping = Set<String>()
    
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

        conversation.members.forEach { member in
            member.typing.asObservable()
                .observeOnMainThread()
                .subscribe(onNext: { self.handleTypingChangedEvent(member: member, isTyping: $0) })
                .addDisposableTo(ConversationClient.instance.disposeBag)
        }

        conversation.memberJoined.addHandler(self, handler: ConversationAssistWidget.handleMemberJoinedEvent)
    }
    
    private func handleTypingChangedEvent(member: Member, isTyping: Bool) {
        /* make sure it is not this user typing */
        if !member.user.isMe {
            let name = member.user.name

            if isTyping {
                whoIsTyping.insert(name)
            } else {
                whoIsTyping.remove(name)
            }

            refreshMessage()
        }
    }
    
    private func handleMemberJoinedEvent(member: Member) {
        member.typing.asObservable()
            .observeOnMainThread()
            .subscribe(onNext: { self.handleTypingChangedEvent(member: member, isTyping: $0) })
            .addDisposableTo(ConversationClient.instance.disposeBag)
    }
    
    public func close() {
        cancelTimer()
    }
    
    private func inflateFromXib() {
        /* Load Xib file. */
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ConversationAssistWidget", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        /* Set layout properties of top level view. */
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        
        /* Add a background blur effect - see http://stackoverflow.com/questions/17055740/how-can-i-produce-an-effect-similar-to-the-ios-7-blur-view */
        blurredBackground = UIToolbar()
        blurredBackground!.barStyle = .default
        insertSubview(blurredBackground!, at: 0)
    }
    
    private func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.active = false
            self.invalidateIntrinsicContentSize()
            self.superview?.layoutIfNeeded()
        })
    }
    
    private func show() {
        /* Show us. */
        UIView.animate(withDuration: 0.3, animations: {
            self.active = true
            self.invalidateIntrinsicContentSize()
            self.superview?.layoutIfNeeded()
        })
        
        /* Set a timer to automatically close. */
        cancelTimer()
        disappearTimer = Timer.scheduledTimer(timeInterval: ConversationAssistWidget.TIMEOUT, target: self, selector: #selector(timeout), userInfo: nil, repeats: false)
    }
    
    @objc private func timeout(sender: AnyObject) {
        cancelTimer()
        hide()
    }
    
    private func cancelTimer() {
        if disappearTimer != nil {
            disappearTimer?.invalidate()
            disappearTimer = nil
        }
    }
    
    private func updateFrame() {
        var newFrame = frame
        
        if active {
            newFrame.size.height = message.intrinsicContentSize.height + 8
        } else {
            newFrame.size.height = 0
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = newFrame
        })
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        blurredBackground?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    override public var intrinsicContentSize: CGSize {
        var result = super.intrinsicContentSize
        
        if active {
            result.height = message.intrinsicContentSize.height + 8
        } else {
            result.height = 0
        }
        
        return result
    }
    
    private func refreshMessage() {
        if !whoIsTyping.isEmpty {
            var caption = whoIsTyping.joined(separator: ", ")
           
            if whoIsTyping.count == 1 {
                caption += " is typing..."
            } else {
                caption += " are typing..."
            }
            
            message.text = caption
            
            show()
        } else {
            message.text = ""
            
            hide()
        }
    }
}
