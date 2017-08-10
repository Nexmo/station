//
//  MessageComposeWidget.swift
//  NexmoChat
//
//  Created by James Green on 24/05/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import NexmoConversation

@IBDesignable public class MessageComposeWidget: UIView, UITextViewDelegate, ImageSelectionDelegate {
    public static let TYPING_INDICATOR_TIMEOUT: TimeInterval = 3.0
    
    @IBOutlet weak var TextEntry: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    private(set) var conversation: Conversation?
    var delegate: MessageComposeDelegate?
    private(set) var isTyping: Bool = false
    private var typingTimer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        inflateFromXib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        inflateFromXib()
    }
    
    private func inflateFromXib() {
        /* Load Xib file. */
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MessageComposeWidget", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        /* Set properties of top level view. */
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        
        /* Misc initialisation. */
        self.TextEntry.layer.borderColor = UIColor.gray.cgColor
        self.TextEntry.layer.borderWidth = 1
        self.TextEntry.layer.cornerRadius = 2
        
        /* Attach to events. */
        TextEntry.delegate = self
    }
    
    public func initialise(conversation: Conversation) {
        self.conversation = conversation
        
        /* For some reason the initial content size of 'TextEntry' is incorrect so the first time
           intrinsicContentSize is calculated it is wrong. So do this work around. */
        // TODO Do better
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 1)) { [weak self] in
            self!.setNeedsLayout()
            self!.invalidateIntrinsicContentSize()
        }
    }
    
    public func close() {
        self.isTyping = false

        if typingTimer != nil {
            stoppedTyping(sender: self)
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        var result = TextEntry.contentSize
        let newHeight = max((result.height - 3 + 10), 40)
        result.height = newHeight
        return result
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        invalidateIntrinsicContentSize()
        scrollToCaret()
        
        /* Send button is only enabled when there is something to send. */
        sendButton.isEnabled = !TextEntry.text.characters.isEmpty
        
        /* Set typing. First see if we need to send an event. */
        if !isTyping {
            conversation?.startTyping()
            
            isTyping = true
        }
        
        /* Restart any timer. */
        cancelTimer()
        typingTimer = Timer.scheduledTimer(timeInterval: MessageComposeWidget.TYPING_INDICATOR_TIMEOUT, target: self, selector: #selector(stoppedTyping), userInfo: nil, repeats: false)
    }
    
    private func scrollToCaret() {
        let rect = TextEntry.caretRect(for: (TextEntry.selectedTextRange?.end)!)
        TextEntry.scrollRectToVisible(rect, animated: false)
    }
    
    private func cancelTimer() {
        if typingTimer != nil {
            typingTimer?.invalidate()
            typingTimer = nil
        }
    }
    
    @objc private func stoppedTyping(sender: AnyObject) {
        self.isTyping = false
        cancelTimer()

        conversation?.stopTyping()
    }
    
    @IBAction func sendButtonPressed(_ sender: AnyObject) {
        /* Trim the string. */
        let text = TextEntry.text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        guard !text.isEmpty else { return }
        
        /* Inform the delegate. */
        delegate?.onTextComposed(text)
        
        /* Clear the text field. */
        TextEntry.text = ""
        invalidateIntrinsicContentSize()
        
        /* Close the keyboard. */
        TextEntry.resignFirstResponder()
    }
    
    @IBAction func AttachmentButtonPressed(_ sender: AnyObject) {
        let selection = AttachmentSelectionViewController.AttachmentSelection()
        // set delegate
        selection.delegate = self
        let vc = MessageComposeWidget.findParentViewController(view: self)
        vc!.present(selection, animated: false)
    }
    
    private static func findParentViewController(view: UIView) -> UIViewController? {
        let responder = view.next

        if responder is UIViewController {
            return responder as? UIViewController
        } else if responder is UIView {
            return findParentViewController(view: responder as! UIView)
        }
        
        return nil
    }
    
    // MARK:
    // MARK: ImageSelectionDelegate
    
    public func onImageSelected(image: UIImage) {
        delegate?.onMessageImageComposed(image)
    }
}
