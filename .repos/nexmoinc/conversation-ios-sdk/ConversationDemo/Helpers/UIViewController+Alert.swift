//
//  UIViewController+Alert.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 01/08/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import UIKit

/// Present an alert
internal protocol PresentAlert {

    // MARK:
    // MARK: Present

    /// Display a alert
    func presentAlert(title: String, message: String?, actionTitle: String?, _ callback: ((UIAlertAction) -> Void)?)
}

internal extension PresentAlert where Self: UIViewController {

    // MARK:
    // MARK: Present

    /// Display a alert
    internal func presentAlert(title: String, message: String?, actionTitle: String?, _ callback: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        if let actionTitle = actionTitle {
            alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: callback))
        }

        present(alert, animated: true)
    }
}
