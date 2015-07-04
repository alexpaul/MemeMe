//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Alex Paul on 6/25/15.
//  Copyright (c) 2015 Alex Paul. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreText

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
                        UITextFieldDelegate
{
    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var cameraBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var settingsBarButtonItem: UIBarButtonItem!

    // MARK: Instance Variables
    
    var defaultFont: String!
    var imagePickerController: UIImagePickerController!
    var memeTextAttributes = [String: NSObject]()
    
    // MARK: View Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.subscribeToKeyboardWillShowNotification()
        self.subscribeToKeyboardWillHideNotification()
        
        setupDefaultTextAttributes()
        setupTextFields()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable Action Bar Button Item
        self.shareBarButtonItem.enabled = false
        
        self.settingsBarButtonItem?.title = NSString(string: "\u{2699}") as? String
        var dict = [NSFontAttributeName: UIFont(name: "Helvetica", size: 24.0)!]
        self.settingsBarButtonItem.setTitleTextAttributes(dict, forState: UIControlState.Normal)
        
        //setupTextFields()
        
        // If Camera isn't present disable Camera Button 
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            self.cameraBarButtonItem.enabled = false
        }
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
            setupCamera()
        }
    }
    
    @IBAction func photosAlbumBarButtonItemPressed(sender: UIBarButtonItem) {
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            
            setupPhotosAlbum()
        }
    }
    
    @IBAction func cancelBarButtonItemPressed(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Share Meme
    @IBAction func shareBarButtonItemPressed(sender: UIBarButtonItem) {
        // Create a Meme Object
        var meme = createMeme()
        
        var activityController = UIActivityViewController(activityItems: [meme.memeImage!], applicationActivities: nil)
        activityController.completionWithItemsHandler = {(activityType, completed: Bool, _, _) in
            if completed {
                // Save the Meme object to the Meme Array in the Meme Shared Model Singleton Instance
                let sharedModel = MemeSharedModel.sharedInstance
                sharedModel.addMemes(meme)
                
                // Change Cancel to Done to indicate Meme was shared and is Done being edited
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "done")
            }
        }
        self.navigationController?.presentViewController(activityController, animated: true, completion: nil)
    }
    
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        // Image was selected
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{ // safe unwrapping of the info[key] object
            self.imageView.image = image
            
            // Enable the Action Bar Button Item
            self.shareBarButtonItem.enabled = true
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
    
    func setupDefaultTextAttributes() {
        if let font = MemeSharedModel.sharedInstance.getMemeFont() {
            self.defaultFont = font
        }else {
            MemeSharedModel.sharedInstance.createMemeFont("Impact")
            if let font = MemeSharedModel.sharedInstance.getMemeFont(){
                self.defaultFont = font
            }
        }
                
        self.memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: self.defaultFont, size: 40)!, // "HelveticaNeue-CondensedBlack"
            NSStrokeWidthAttributeName: -4.0]
    }
    
    func setupTextFields() {
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        
        self.topTextField.defaultTextAttributes = self.memeTextAttributes
        self.bottomTextField.defaultTextAttributes = self.memeTextAttributes
        
        self.topTextField.textAlignment = NSTextAlignment.Center
        self.bottomTextField.textAlignment = NSTextAlignment.Center
        
        if self.topTextField.text == "" {
            self.topTextField.text = "TOP"
        }
        if self.bottomTextField.text == "" {
            self.bottomTextField.text = "BOTTOM"
        }
    }
    
    func setupCamera(){
        self.imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.imagePickerController.allowsEditing = false
        self.imagePickerController.mediaTypes = [kUTTypeImage] // capture still images ONLY
        self.presentViewController(self.imagePickerController, animated: true, completion: nil)
    }
    
    func setupPhotosAlbum(){
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
    
    func done() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
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

