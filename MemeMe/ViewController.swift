//
//  ViewController.swift
//  MemeMe
//
//  Created by Alex Paul on 6/25/15.
//  Copyright (c) 2015 Alex Paul. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreText

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
                        UITextFieldDelegate
{
    // IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var actionBarButtonItem: UIBarButtonItem!
    

    var imagePickerController: UIImagePickerController!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -4.0]
        // NSStrokeWidthAttributeName needs to be a negative number
        // http://stackoverflow.com/questions/30955277/nsforegroundcolorattributename-doesnt-work-in-swift
    
    // MARK: View Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardWillShowNotification()
        self.subscribeToKeyboardWillHideNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable Action Bar Button Item
        self.actionBarButtonItem.enabled = false
        
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
    
        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.defaultTextAttributes = memeTextAttributes
        
        self.topTextField.textAlignment = NSTextAlignment.Center
        self.bottomTextField.textAlignment = NSTextAlignment.Center
        
        self.topTextField.text = "TOP"
        self.bottomTextField.text = "BOTTOM"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardWillShowNotification()
        self.unsubsribeToKeyboardWillHideNotification()
    }
    
    // MARK: IBActions
    
    @IBAction func cameraBarButtonItemPressed(sender: UIBarButtonItem) {
        
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
            && UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
        {
            var alert = UIAlertController(title: "MemeMe Photo", message: "Take Photo or Choose from Camera Roll",
                preferredStyle: UIAlertControllerStyle.ActionSheet)
            
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
            
            var alert = UIAlertController(title: "MemeMe Photo", message: "Choose From Camera Roll",
                preferredStyle: UIAlertControllerStyle.ActionSheet)
            
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
    
    @IBAction func actionBarButtonItemPressed(sender: UIBarButtonItem) {
        // Create a Meme Object
        var meme = createMeme()
        
        // Save the Meme object to the Meme Array in the Meme Shared Model Singleton Instance 
        let sharedModel = MemeSharedModel.sharedInstance
        sharedModel.addMemes(meme)
        println("There are \(sharedModel.memesCount()) memes")
        
        // Share Meme
        var activityController = UIActivityViewController(activityItems: [meme.memeImage!], applicationActivities: nil)
        self.navigationController?.presentViewController(activityController, animated: true, completion: nil)
    }
    
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        // Image was selected
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{ // safe unwrapping of the info[key] object
            self.imageView.image = image
            
            // Enable the Action Bar Button Item
            self.actionBarButtonItem.enabled = true
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
    
    func createMeme() -> Meme{
        var meme = Meme(topMeme: self.topTextField.text, bottomMeme: bottomTextField.text,
            originalImage: self.imageView.image!, memeImage: generateMemeImage())
        return meme
    }
    
    func generateMemeImage() -> UIImage{
        // Hide the navbar and toolbar
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.toolbarHidden = true
        
        // Render the View as an Image
        UIGraphicsBeginImageContext(self.view.frame.size) // view controller's view
        let renderFrameSize: CGRect = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - 20, width: self.view.frame.width, height: self.view.frame.height + 20)
        self.view.drawViewHierarchyInRect(renderFrameSize, afterScreenUpdates: true) //self.view.frame
        let memeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show the navbar and toolbar
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.toolbarHidden = false
        
        return memeImage
    }
    
    // MARK: Keyboard Adjustment
    
    func subscribeToKeyboardWillShowNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:",
            name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardWillShowNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification,
            object: nil)
    }
    
    func subscribeToKeyboardWillHideNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:",
            name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubsribeToKeyboardWillHideNotification(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification){
        // Only adjust view when bottom text field is being edited
        if self.bottomTextField.isFirstResponder(){
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if self.bottomTextField.isFirstResponder(){
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }


}

