//
//  SettingsViewController.swift
//  NexmoConversation
//
//  Created by Josephine Humphreys on 29/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import UIKit
import NexmoConversation
import netfox

internal class SettingsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK:
    // MARK: Lifecycle
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK:
    // MARK: View
    
    private func setupView() {
        tableView.tableFooterView = UIView()
    }
    
    // MARK:
    // MARK: Account

    fileprivate func logout() {
        ConversationClient.instance.logout()
    }
    
    fileprivate func goToLoginScreen() {
        let storyboard = UIStoryboard.storyboard(.main)
        let viewController: LoginViewController = storyboard.instantiateViewController()
        
        navigationController?.setViewControllers([viewController], animated: true)
    }
    
    // MARK:
    // MARK: Logger
    
    /// Display network logger
    internal func showNetworkLogs() {
        NFX.sharedInstance().show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let hideButton = UIBarButtonItem(
                barButtonSystemItem: .done,
                target: NFX.sharedInstance(),
                action: #selector(NFX.hide)
            )
            
            if let viewController = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController {
                (viewController as? UINavigationController)?.topViewController?.navigationItem.leftBarButtonItem = hideButton
            }
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    // MARK:
    // MARK: UITableViewDataSource

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Logout"
        case 1:
            cell.textLabel?.text = "Push notification token"
            cell.detailTextLabel?.text = ConversationClient.instance.deviceToken
        case 2:
            cell.textLabel?.text = "Network logs"
        default: break
        }
        
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    // MARK:
    // MARK: UITableViewDelegate
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            logout()
            goToLoginScreen()
        case 1:
            UIPasteboard.general.string = tableView.cellForRow(at: indexPath)?.detailTextLabel?.text
        case 2:
            showNetworkLogs()
        default: break
        }
    }
}
