//
//  AttachmentSelectionCoordinator.swift
//  ConversationDemo
//
//  Created by shams ahmed on 21/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import AVFoundation

/// Coordinator for conversation selection screen
internal struct AttachmentSelectionCoordinator {
    
    /// Main root view controller 
    internal let rootViewContoller: UIViewController
    
    // MARK:
    // MARK: Present
    
    /// Present camera view controller
    internal func presentCamera() {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        guard let rootViewContoller = rootViewContoller as? UIImagePickerControllerDelegate & UINavigationControllerDelegate else {
            // fine to have fatal error here, since it controlled by developer
            fatalError("\(self.rootViewContoller) does not conform to correct protocols)")
        }
        
        picker.delegate = rootViewContoller
        
        (rootViewContoller as? UIViewController)?.present(picker, animated: true)
    }
    
    /// Present photo library view controller
    internal func presentPhotoLibaray() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        
        guard let rootViewContoller = rootViewContoller as? UIImagePickerControllerDelegate & UINavigationControllerDelegate else {
            // fine to have fatal error here, since it controlled by developer
            fatalError("\(self.rootViewContoller) does not conform to correct protocols)")
        }
        
        picker.delegate = rootViewContoller
        
        (rootViewContoller as? UIViewController)?.present(picker, animated: true)
    }
    
    // MARK:
    // MARK: Auth
    
    /// Validate if user has giving permission for camera access
    ///
    /// - returns: access result
    internal func userHasCameraAuthorisation() -> Bool {
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
        case .authorized: return true
        default: return false
        }
    }
}
