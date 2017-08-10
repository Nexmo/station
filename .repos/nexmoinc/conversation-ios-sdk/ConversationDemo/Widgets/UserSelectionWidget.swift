//
//  UserSelectionWidget.swift
//  NexmoChat
//
//  Created by James Green on 08/06/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import NexmoConversation

@IBDesignable public class UserSelectionWidget: UIView, UITextFieldDelegate {
    @IBOutlet weak var userTypeControl: UISegmentedControl!
    @IBOutlet weak var memberName: UITextField!    
    @IBOutlet weak var addButton: UIButton!
    
    public weak var delegate: UserSelectionDelegate?

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

    // MARK:
    // MARK: Setup

    private func inflateFromXib() {
        /* Load Xib file. */
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "UserSelectionWidget", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        /* Set properties of top level view. */
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        
        /* Initialise components. */
        memberName.addTarget(self, action: #selector(memberNameChanged), for: .editingChanged)

        updateEnablements()
    }

    // MARK:
    // MARK: UI

    @objc private func memberNameChanged(sender: AnyObject) {
        updateEnablements()
    }
    
    private func updateEnablements() {
        if memberName.text?.isEmpty == true {
            addButton.isEnabled = false
        } else {
            addButton.isEnabled = true
        }
    }

    // MARK:
    // MARK: UITextFieldDelegate

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /* Close keyboard on done button. */
        textField.resignFirstResponder()

        return true
    }
    
    @IBAction func addButtonPressed(_ sender: AnyObject) {
        /* Inform delegate. */
        delegate?.onUserSelected(user: memberName.text!)
        
        /* Clear our text. */
        memberName.text = ""
        updateEnablements()
    }
}
