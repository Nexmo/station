//
//  AuthViewController.swift
//  NexmoChat
//
//  Created by Jonathan Tilley on 12/05/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import NexmoConversation

/// UserDefault keys
///
/// - username: username
internal enum UserDefaultKey: String {
    case username = "Nexmo_Conversation_Demo_Username"
}

/**
 This is the View Controller for the login screen. It's purpose is to pass the username and
 password on to the Session singleton. If you don't want to use this login screen, that is
 ok, but you must ensure Session has everything to make it happy.
 */
public class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var authButton: UIButton!
    
    @IBOutlet private weak var failureMessageLabel: UILabel!
    @IBOutlet private weak var versionLabel: UILabel!
    
    private let authenticationService = AuthenticationService()
    
    // MARK:
    // MARK: Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        authButtonPressed(self)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK:
    // MARK: Setup
    
    private func setupUI() {
        failureMessageLabel.isHidden = true
        
        usernameTextField.text = UserDefaults.standard.string(forKey: UserDefaultKey.username.rawValue)
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionLabel.text = "v" + version
        }
    }
    
    // MARK:
    // MARK: Action
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        guard let username = usernameTextField.text?.replacingOccurrences(of: " ", with: ""), !username.isEmpty else { return }
        guard let password = passwordTextField.text?.replacingOccurrences(of: " ", with: ""), !password.isEmpty else { return }
        
        print("Logging in...")
        
        failureMessageLabel.isHidden = true

        save(username)
        validateUsername(username, with: password) { [weak self] model in self?.login(model.token) }
    }
    
    @IBAction func authButtonPressed(_ sender: AnyObject) {
        // Check the token in environment variable, can be found in target scheme setting under build
        guard let token = ProcessInfo.processInfo.environment[Constants.EnvironmentArgumentKey.nexmoToken.rawValue],
            !token.isEmpty else {
            print("Demo - auth token not in environment variable, set in target scheme setting under build")
            
            return
        }
        
        print("Demo - launching with tokens in environment variable")
            
        login(token)
    }
    
    // MARK:
    // MARK: UITextFieldDelegate
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        failureMessageLabel.isHidden = true
    
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    // MARK:
    // MARK: Login
    
    /// Login with token
    private func login(_ token: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        appDelegate.client.login(with: token)
            .subscribe(onSuccess: { [weak self] in
                let storyboard = UIStoryboard.storyboard(.main)
                let viewController: ConversationListViewController = storyboard.instantiateViewController()
                
                self?.navigationController?.setViewControllers([viewController], animated: false)
                
                print("DEMO - login successful")
            }, onError: { [weak self] error in
                self?.failureMessageLabel.isHidden = false

                let reason: String = {
                    switch error {
                    case LoginResult.failed: return "failed"
                    case LoginResult.invalidToken: return "invalid token"
                    case LoginResult.sessionInvalid: return "session invalid"
                    case LoginResult.expiredToken: return "expired token"
                    case LoginResult.success: return "success"
                    default: return "unknown"
                    }
                }()

                print("DEMO - login unsuccessful with \(reason)")
            })
            .addDisposableTo(appDelegate.client.disposeBag)
    }
    
    /// Authenticate user with username and password
    private func validateUsername(_ username: String, with password: String, _ completion: @escaping (AuthenticationModel) -> Void) {
        authenticationService.validate(email: username, password: password) { [weak self] result in
            switch result {
            case .success(let model):
                completion(model)
            case .failure(_):
                print("DEMO - auth unsuccessful")
                
                self?.failureMessageLabel.isHidden = false
            }
        }
    }
    
    // MARK:
    // MARK: UserDefault

    /**
     Store the username and password persistently.
     
     - parameter username: Username, nil to clear.
     - parameter password: Password, nil to clear.
     */
    private func save(_ username: String) {
        let preferences = UserDefaults.standard
        
        preferences.set(username, forKey: UserDefaultKey.username.rawValue)
        preferences.synchronize()
    }
}
