//
//  MessageBubbleTextCell
//  Nexmo
//
//  Created by Jonathan Tilley on 13/04/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//
import UIKit
import NexmoConversation

public class MessageBubbleView: UITableViewCell {
    
    /// Message Type
    ///
    /// - PlainText: text event
    /// - Image:     image event type with the unwrapped value
    public enum MessageType {
        case PlainText
        case Image(ImageEvent)
    }
    
    /* Constants. */
    private static let maxBubbleProportion: CGFloat = 0.75 // The maximum width proportion that a bubble can take.
    private static let avatarSize: CGFloat = 32 // The width and height of the avatar.
    private static let avatarToContainerPadding: CGFloat = 8 // When on the LHS the space between the avatar and the container
    private static let containerMargin: CGFloat = 4 // The top, left, right, bottom margins used by any components inside the container.
    private static let containerVerticalPadding: CGFloat = 4 // The vertical padding between any components in the container
    private static let nameLabelHeight: CGFloat = 16
    private static let dateLabelHeight: CGFloat = 17
    private static let MessageLabelFont: UIFont = UIFont.systemFont(ofSize: 17.0)
    private static let interCellSpacing: CGFloat = 5 // The blank space between cells
    private static let spaceRequiredToPutDateOnSameLine: CGFloat = 120
    private static let statusImageWidth: CGFloat = 22 // 32
    
    /* Outlets tied to the Xib file. */
    @IBOutlet weak var avatar: AvatarWidget!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var payloadContainer: UIView!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var avatarLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var avatarWidth: NSLayoutConstraint!
    @IBOutlet weak var avatarHeight: NSLayoutConstraint!

    @IBOutlet var containerLeading: NSLayoutConstraint! // This is not weak on purpose. We change the active property of the constraint but don't want it to be garbage collected away.
    @IBOutlet var containerTrailing: NSLayoutConstraint! // This is not weak on purpose. We change the active property of the constraint but don't want it to be garbage collected away.
    @IBOutlet weak var containerWidth: NSLayoutConstraint!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!

    @IBOutlet weak var nameTopMargin: NSLayoutConstraint!
    @IBOutlet weak var nameLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var nameHeight: NSLayoutConstraint!

    @IBOutlet weak var payloadTopPadding: NSLayoutConstraint!
    @IBOutlet weak var payloadHeight: NSLayoutConstraint!

    @IBOutlet weak var messageTopPadding: NSLayoutConstraint!
    
    @IBOutlet weak var dateHeight: NSLayoutConstraint!
    
    @IBOutlet weak var statusIconWidth: NSLayoutConstraint!
    @IBOutlet weak var statusIconPadding: NSLayoutConstraint!
    
    /* Properties. */
    private(set) var message: TextEvent?
    
    /// Is the avatar enabled? Note that enabled just leaves space for it, whether
    /// or not it is actually shown depends on other factors such as whether the
    /// name is shown.
    private(set) var avatarEnabled: Bool
    
    /// Is the bubble rendered on the right or left?
    private(set) var onLeft: Bool = true
    
    /// Set the name to be shown. Nil disabled showing of name. The update the UI accordingly.
    /// If the name is shown, the avatar will be shown (if avatars enabled).
    private(set) var name: String?
    
    var XibRootView: UIView?
    var parentWidth: CGFloat
    
    /**
     Given a message, determine its type.
     
     - parameter message: Message
     
     - returns: Its type, defaulting to PlainText if one could not be determined.
     */
    static func getMessageType(message: EventBase) -> MessageType {
        if let message = message as? ImageEvent {
            return .Image(message)
        } else if message is TextEvent {
            return .PlainText
        }
        
        return .PlainText
    }
    
    /**
     Given a message, determine the reuseId of the cell that should render it.
     
     - parameter message: Message     
     - returns: String containing the reuseId
     */
    static func getReuseId(message: EventBase) -> String {
        switch getMessageType(message: message) {
            case .Image: return "MessageBubbleImaegView"
            default: return "MessageBubbleView"
        }
    }

    /**
     Factory method to create a Message Bubble widget of the appropriate subclass
     type for the payload of the message.
     
     - parameter message: The Message to be rendered.
     
     - returns: An instance of a Message Bubble subclass.
     */
    static func Factory(onLeft: Bool, message: TextEvent, parentWidth: CGFloat, avatarEnabled: Bool, name: String?) -> MessageBubbleView {
        switch getMessageType(message: message) {
        case .Image(let message):
            return MessageBubbleImageView(message: message, onLeft: onLeft, parentWidth: parentWidth, avatarEnabled: avatarEnabled, name: name)
        default:
            return MessageBubbleView(onLeft: onLeft, message: message, parentWidth: parentWidth, avatarEnabled: avatarEnabled, name: name)
        }
    }

    /**
     Returns an object initialized from data in a given unarchiver.
     
     - parameter aDecoder: An unarchiver object.
     
     - returns: self, initialized using the data in decoder.
     */
    required public init?(coder aDecoder: NSCoder) {
        parentWidth = 0
        avatarEnabled = true
        name = nil
        message = nil
        super.init(coder:aDecoder)
        self.selectionStyle = .none
    }

    /**
     Constructor.
     
     - parameter message: The message.
     
     - returns: A new instance.
     */
    public init(onLeft: Bool, message: TextEvent, parentWidth: CGFloat, avatarEnabled: Bool, name: String?) {
        /* Call base class, and set our reuseId. */
        self.onLeft = onLeft
        self.parentWidth = parentWidth
        self.avatarEnabled = avatarEnabled
        self.name = name
        self.message = message
        
        super.init(style: .default, reuseIdentifier: MessageBubbleView.getReuseId(message: message))
        self.selectionStyle = .none
        
        /* Inflate our template contents from the Xib file. */
        XibRootView = Bundle.main.loadNibNamed("MessageBubbleView", owner: self, options: nil)?.first as? UIView
        self.contentView.addSubview(XibRootView!)

        /* Override certain constraints to use the constants defined in this file. */
        if avatarEnabled {
            avatarLeftMargin.constant = MessageBubbleView.containerMargin
            avatarWidth.constant = MessageBubbleView.avatarSize
            avatarHeight.constant = MessageBubbleView.avatarSize
            containerLeading.constant = MessageBubbleView.avatarToContainerPadding
        } else {
            avatarLeftMargin.constant = 0
            avatarWidth.constant = 0
            avatarHeight.constant = 0
            containerLeading.constant = MessageBubbleView.containerMargin
        }
        
        containerTrailing.constant = MessageBubbleView.containerMargin
        
        nameTopMargin.constant = MessageBubbleView.containerMargin
        nameLeftMargin.constant = MessageBubbleView.containerMargin
        
        dateHeight.constant = MessageBubbleView.dateLabelHeight
        
        /* Set the message text font. */
        messageText.font = MessageBubbleView.MessageLabelFont
        
        /* Tweak appearances. */
        container.layer.cornerRadius = 2
        payloadContainer.layer.cornerRadius = 2
        
        /* Set the contents. */
        updateUIwithMessage(message: message)
    }
    
    /**
     Calculate the width of the container.
     
     - parameter parentWidth: Width of superview.
     - parameter avatarShown: Whether or not the avatar is being shown.
     
     - returns: The width.
     */
    private static func CalculateContainerWidth(message: TextEvent, parentWidth: CGFloat, avatarEnabled: Bool) -> CGFloat {
        /* First work out the available width of the container. The availableWidth will have had the internal margin subtracted. */
        var availableWidth: CGFloat = parentWidth
        
        if avatarEnabled {
            availableWidth -= (MessageBubbleView.avatarSize + MessageBubbleView.avatarToContainerPadding)
        }
        availableWidth -= containerMargin // For the left margin to either the avatar, or the container
        availableWidth -= containerMargin // Right margin of the container
        
        availableWidth = ((availableWidth * maxBubbleProportion) - (2 * containerMargin))
        
        /* Now see if there is a payload, and if it wants to override the width. */
        let payloadWidth = MessageBubbleView.payloadWidthForMessage(message: message, availableWidth: availableWidth)
        if payloadWidth > 0 {
            /* If the payload is specifying a width, then it overrides the availableWidth, probably reducing the space available (but it could make it bigger). */
            availableWidth = payloadWidth
        } else {
            /* If the payload hasn't overriden the width, then the width is deterived from the message text and
               depends on how many characters it has, and how it wraps etc. */
            
            let text: String
            if message.text == nil {
                text = ""
            } else {
                text = message.text!
            }
            
            let boundingBox = text.boundingBox(availableWidth: availableWidth, font: MessageBubbleView.MessageLabelFont)
            
            /* We have to identify very short messages because we might be able to fit the date on the same line. Eg.
             
                        xxxx xxxxx xxxx        12:34 •••
             */
            let isOnOneLine = (boundingBox.height <= (2 * MessageBubbleView.MessageLabelFont.pointSize))
            if isOnOneLine {
                // TODO - Make spaceRequiredToPutDateOnSameLine take in to account whether status icon is showing, ie. LHS vs RHS
                if boundingBox.width + MessageBubbleView.spaceRequiredToPutDateOnSameLine <= availableWidth {
                    availableWidth = (boundingBox.width + MessageBubbleView.spaceRequiredToPutDateOnSameLine)
                }
            }
            
        }
        
        let result = (availableWidth + (2 * containerMargin))
        return result
    }
    
    /**
     Calculate the height of the payload. If no payload, zero is returned.
     
     - parameter message: The message.
     
     - returns: The height, or zero.
     */
    static func payloadHeightForMessage(message: EventBase, parentWidth: CGFloat) -> CGFloat {
        // TODO: refactor why does view need to knoe about events... pass only image
        switch getMessageType(message: message) {
        case .Image(let message):
            guard let data = message.image, let image = UIImage(data: data) else { return 0 }
            
            return MessageBubbleImageView.payloadHeightFor(image: image, parentWidth: parentWidth)
        default: return 0
        }
    }

    /**
     Calculate the width of the payload. If no payload, zero is returned.
     
     - parameter message: The message.
     
     - returns: The width, or zero.
     */
    static func payloadWidthForMessage(message: TextEvent, availableWidth: CGFloat) -> CGFloat {
        // TODO: refactor why does view need to know about events... pass only image
        switch getMessageType(message: message) {
            case .Image(let message):
                guard let data = message.image, let image = UIImage(data: data) else { return 0 }
                
                return MessageBubbleImageView.payloadWidthFor(image: image, availableWidth: availableWidth)
            default: return 0
        }
    }
    
    static func cellHeightForMessage(message: TextEvent, parentWidth: CGFloat, avatarEnabled: Bool, showName: Bool) -> CGFloat {
        var result: CGFloat = 0
        
        /* Are we showing the name? */
        if showName {
            result += (nameLabelHeight + containerMargin)
        }
        
        /* Are we showing a payload? */
        let payloadHeight: CGFloat = payloadHeightForMessage(message: message, parentWidth: parentWidth)
        if payloadHeight > 0 {
            result += (payloadHeight + containerVerticalPadding)
        }
        
        /* If we are showing either the name or a payload, then the message needs some vertical padding before it.
         Otherwise, the message is the first thing in the widget so it just needs margin rather than padding. */
        if showName || payloadHeight > 0 {
            result += containerVerticalPadding
        } else {
            result += containerMargin
        }
        
        /* Work out the available width that the message label has to play with. */
        let containerWidth = MessageBubbleView.CalculateContainerWidth(message: message, parentWidth: parentWidth, avatarEnabled: avatarEnabled)
        let availableWidth = (containerWidth - (2 * containerMargin))
        
        if message is ImageEvent {
            result += (dateLabelHeight + containerVerticalPadding)
        } else {
            let text: String
            if message.text == nil {
                text = ""
            } else {
                text = message.text!
            }
                
            let messageBoundingBox = text.boundingBox(availableWidth: availableWidth, font: MessageBubbleView.MessageLabelFont)
            
            /* For the last line of the text, work out where the last character is, so we can tell if the date can
             be fitted on the same line, or whether we need to introduce some additional padding to move the date
             down by (appropixmately) one line. */
            let lastCharPos = MessageBubbleView.LastCharPosition(text: text, availableWidth: availableWidth, font: MessageBubbleView.MessageLabelFont)
            let desiredWidth = (lastCharPos + MessageBubbleView.spaceRequiredToPutDateOnSameLine)
            if desiredWidth > availableWidth + 1 { // Add 1 to availableWidth because we've calculated things exactly above and there might be a problem with extreme precisions.
                result += (dateLabelHeight + containerVerticalPadding)
            }
            
            result += messageBoundingBox.height
        }
        
        result += containerMargin
        
        result += interCellSpacing
        
        return result
    }
    
    private static func LastCharPosition(text: String, availableWidth: CGFloat, font: UIFont) -> CGFloat {
        if text.characters.isEmpty {
            return 0
        }
        
        // TODO - May want to consider caching this result as it is quite expensive to calculate.
        let attributedString = NSAttributedString(string: text, attributes: [NSFontAttributeName: font])
        let textStorage = NSTextStorage(attributedString: attributedString)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: CGSize(width: availableWidth, height: CGFloat.greatestFiniteMagnitude))
        textContainer.lineFragmentPadding = 0
        layoutManager.addTextContainer(textContainer)
        let location = layoutManager.location(forGlyphAt: text.characters.count - 1)
        return location.x
    }

    public func updateMessage(onLeft: Bool, message: TextEvent, name: String?) {
        self.onLeft = onLeft
        self.name = name
        updateUIwithMessage(message: message)
    }
    
    /**
     Refresh our contents with the given message.
     
     - parameter message: The message.
     */
    private func updateUIwithMessage(message: TextEvent) {
        self.message = message
        
        /* Mark as seen (if it's a message sent to us). */
        if onLeft {
            message.markAsSeen()
        }
        
        /* Set contents. */
        if message is ImageEvent {
            messageText.text = ""
        } else {
            messageText.text = message.text
        }
        
        nameLabel.text = message.from.displayName
        dateLabel.text = DateHelper.prettyPrint(message.createDate)
        if onLeft {
            container.backgroundColor = Styling.RX_MESSAGE_BG_COLOR
            nameLabel.textColor = UIColor.darkGray
            messageText.textColor = UIColor.black
            dateLabel.textColor = UIColor.darkGray
        } else {
            if message.isCurrentlyBeingSent {
                // TODO Have a nice icon to indicate a message that is being sent rather than just an ugly background colour change.
                container.backgroundColor = Styling.TX_IN_TRANSIT_MESSAGE_BG_COLOR
            } else {
                container.backgroundColor = Styling.TX_MESSAGE_BG_COLOR
            }
            nameLabel.textColor = Styling.SNOW_COLOR
            messageText.textColor = UIColor.white
            dateLabel.textColor = Styling.SNOW_COLOR
        }
        
        /* Status. */
        updateMessageStatus()
        
        /* Avatar. */
        let showAvatar = (avatarEnabled && (name != nil) && onLeft)
        avatar.isHidden = !showAvatar
        if showAvatar {
            avatar.user = message.from
        }
        
        /* Update name height and padding. */
        if name != nil {
            nameHeight.constant = MessageBubbleView.nameLabelHeight
            nameLabel.text = name
        } else {
            nameHeight.constant = 0
            nameLabel.text = ""
        }
        
        /* Update payload height and padding. */
        let pHeight: CGFloat = MessageBubbleView.payloadHeightForMessage(message: message, parentWidth: parentWidth)
        payloadHeight.constant = pHeight
        if name != nil && pHeight > 0 {
            payloadTopPadding.constant = MessageBubbleView.containerVerticalPadding
        } else {
            payloadTopPadding.constant = 0
        }
        
        /* Update message text label's padding. */
        if name != nil || pHeight > 0 {
            messageTopPadding.constant = MessageBubbleView.containerVerticalPadding
        } else {
            messageTopPadding.constant = 0
        }
        
        /* Update container width to take parent width in to account. */
        containerWidth.constant = MessageBubbleView.CalculateContainerWidth(message: message, parentWidth: parentWidth, avatarEnabled: avatarEnabled)
        let height: CGFloat = MessageBubbleView.cellHeightForMessage(message: message, parentWidth: parentWidth, avatarEnabled: avatarEnabled, showName: (name != nil))
        containerHeight.constant = (height - MessageBubbleView.interCellSpacing)
        
        /* Put the container on the left or on the right. */
        if onLeft {
            containerLeading.isActive = true
            containerTrailing.isActive = false
        } else {
            containerLeading.isActive = false
            containerTrailing.isActive = true
        }
        
        /* Update frame sizes. */
        let frame: CGRect = CGRect(x: 0, y: 0, width: parentWidth, height: height)
        XibRootView!.frame = frame
        contentView.frame = frame
        
        /* Subscribe to receipt events. */
        newReceiptRecordRef?.dispose() // Out with the old
        receiptRecordChangedRef?.dispose() // Out with the old
        newReceiptRecordRef = self.message!.newReceiptRecord.addHandler(self, handler: MessageBubbleView.messageStatusChanged)
        receiptRecordChangedRef = self.message!.receiptRecordChanged.addHandler(self, handler: MessageBubbleView.messageStatusChanged)
    }
    
    private var newReceiptRecordRef: SignalReference?
    private var receiptRecordChangedRef: SignalReference?
    
    private func messageStatusChanged(event: TextEvent, receipt: ReceiptRecord) {
        updateMessageStatus()
    }
    
    private func updateMessageStatus() {
        /* Determine the status of the message. There are three stages:
                1) Sent by us to the server.
                2) Delivered from the server to all receipients.
                3) Seen/read by all receipients.
         */
        
        /* If not sent by us, ie. it's a received message, do nothing. */
        if onLeft {
            statusIconWidth.constant = 0
            statusIconPadding.constant = 0
        } else {
            /* It has been sent by us, which stage is it at? */
            var deliveredCount = 0
            var seenCount = 0
            let participantsOtherThanUs = (self.message!.distribution.count - 1)
            
            for receipt in ((self.message?.allReceipts)! as NexmoConversation.LazyCollection<ReceiptRecord>) {
                if !receipt.member.user.isMe {
                    if receipt.state == .seen {
                        seenCount += 1
                        deliveredCount += 1
                    } else if receipt.state == .delivered {
                        deliveredCount += 1
                    }
                }
            }
            
            if seenCount >= participantsOtherThanUs {
                statusImage.image = UIImage(named: "SentDeliveredRead")
            } else if deliveredCount >= participantsOtherThanUs {
                statusImage.image = UIImage(named: "SentDelivered")
            } else if !self.message!.isCurrentlyBeingSent {
                statusImage.image = UIImage(named: "Sent")
            } else {
                statusImage.image = nil
            }
            
            statusIconWidth.constant = MessageBubbleView.statusImageWidth
            statusIconPadding.constant = MessageBubbleView.containerMargin
        }
    }
}
