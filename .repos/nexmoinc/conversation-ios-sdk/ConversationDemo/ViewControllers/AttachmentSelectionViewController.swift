//
//  AttachmentSelectionViewController.swift
//  NexmoChat
//
//  Created by James Green on 31/05/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import NexmoConversation

public class AttachmentSelectionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak private var container: UIView!
    @IBOutlet weak private var cancelButton: UIButton!
    @IBOutlet weak private var stackViewBackground: UIView!
    @IBOutlet weak private var cameraButton: UIButton!
    @IBOutlet weak private var libraryButton: UIButton!
    
    public weak var delegate: ImageSelectionDelegate?
    
    public static func AttachmentSelection() -> AttachmentSelectionViewController {
        /* Create a new view controller. */
        let storyboard = UIStoryboard.storyboard(.main)
        let result: AttachmentSelectionViewController = storyboard.instantiateViewController()
        
        /* Set View Controller to appear on top of previous view controller. */
        result.providesPresentationContextTransitionStyle = true
        result.definesPresentationContext = true
        result.modalPresentationStyle = .overCurrentContext
        result.modalTransitionStyle = .crossDissolve
        
        return result
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Tweak appearance. */
        stackViewBackground.layer.cornerRadius = 4
        cancelButton.layer.cornerRadius = 4
        
        /*cameraButton.layer.borderColor = UIColor.blackColor().CGColor
        cameraButton.layer.borderWidth = 4
        cameraButton.layer.cornerRadius = 4
        libraryButton.layer.borderColor = UIColor.blackColor().CGColor
        libraryButton.layer.borderWidth = 4
        libraryButton.layer.cornerRadius = 4*/
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /* Fade in grey background, slide up view. */
        let originalFrame = container.frame
        var offScreenFrame = originalFrame
        offScreenFrame.origin.y += (view.frame.size.height - originalFrame.origin.y) + 50
        container.frame = offScreenFrame
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
            self.container.frame = originalFrame
        })
    }
    
    // MARK:
    // MARK: Action
    
    @IBAction func cameraButtonPressed(_ sender: AnyObject) {
        AttachmentSelectionCoordinator(rootViewContoller: self).presentCamera()
    }
    
    @IBAction func pictureLibraryButtonPressed(_ sender: AnyObject) {
        AttachmentSelectionCoordinator(rootViewContoller: self).presentPhotoLibaray()
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true)
    }
    
    // MARK:
    // MARK: UINavigationControllerDelegate

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false, completion: {
            self.dismiss(animated: false)
        })
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: false, completion: {
            self.dismiss(animated: false)
            
            guard let image = (info[UIImagePickerControllerEditedImage] ?? info[UIImagePickerControllerOriginalImage] as Any) as? UIImage else { return }
            
            // TODO scale down... too much debug and makes app slow
            self.delegate?.onImageSelected(image: self.resizeImage(image: image, newWidth: 100))
        })
    }
    
    // MARK:
    // MARK: Image Processing
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
