//
//  ViewController.swift
//  MemeMe
//
//  Created by Alex Paul on 6/25/15.
//  Copyright (c) 2015 Alex Paul. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
                        UITextFieldDelegate
{
    // IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!

    var imagePickerController: UIImagePickerController!
    
    let memeTextAttributes = [NSStrokeColorAttributeName: UIColor.blackColor(), NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: 3.0]
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        
        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.defaultTextAttributes = memeTextAttributes
        
        self.topTextField.textAlignment = NSTextAlignment.Center
        self.bottomTextField.textAlignment = NSTextAlignment.Center
        
        self.topTextField.text = "TOP"
        self.bottomTextField.text = "BOTTOM"
    }
    
    // MARK: IBActions
    
    @IBAction func pickBarButtonItemPressed(sender: UIBarButtonItem) {
        
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
            && UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
        {
            var alert = UIAlertController(title: "MemeMe Photo", message: "Take Photo or Choose from Camera Roll", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            var actionTakePhoto = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default){
                UIAlertAction in
                self.cameraActionHandler()
            }
            
            var actionCameraRoll = UIAlertAction(title: "Camera Roll", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.cameraRollActionHandler()
            }
            
            var actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel){
                UIAlertAction in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            alert.addAction(actionCameraRoll)
            alert.addAction(actionTakePhoto)
            alert.addAction(actionCancel)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        else if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            
            var alert = UIAlertController(title: "MemeMe Photo", message: "Choose From Camera Roll", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            var actionCameraRoll = UIAlertAction(title: "Camera Roll", style: UIAlertActionStyle.Default){
                UIAlertAction in
                self.cameraRollActionHandler()
            }
            
            var actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel){
                UIAlertAction in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            alert.addAction(actionCameraRoll)
            alert.addAction(actionCancel)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{ // safe unwrapping of the info[key] object
            self.imageView.image = image
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // MARK: UITextFieldDelegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == self.topTextField && self.topTextField.text == "TOP"{
            self.topTextField.text = ""
        }
        if textField == self.bottomTextField && self.bottomTextField.text == "BOTTOM"{
            self.bottomTextField.text = ""
        }
        
        // TODO: Fix keyboard hiding bottom text field
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Helper Methods
    
    func cameraActionHandler(){
        self.imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.imagePickerController.allowsEditing = false
        self.imagePickerController.mediaTypes = [kUTTypeImage] // capture still images ONLY
        self.presentViewController(self.imagePickerController, animated: true, completion: nil)
    }
    
    func cameraRollActionHandler(){
        self.imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.imagePickerController.allowsEditing = false
        self.presentViewController(self.imagePickerController, animated: true, completion: nil)
    }


}

