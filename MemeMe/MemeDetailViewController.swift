//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Alex Paul on 6/28/15.
//  Copyright (c) 2015 Alex Paul. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    // MARK: Instance Variables
    
    var meme: Meme!
    var sharedModel: MemeSharedModel!
    var memeImageView: UIImageView!
    
    // MARK: View Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get the Meme Model Instance
        self.sharedModel = MemeSharedModel.sharedInstance
        
        // Configure the Meme Image View
        self.memeImageView = UIImageView(frame: CGRect(
            x: self.view.frame.origin.x,
            y: self.view.frame.origin.y + (20 + 44),
            width: self.view.frame.width,
            height: self.view.frame.height - (20 + 44 + 44)))
        self.memeImageView.image = self.meme.memeImage
        self.memeImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(self.memeImageView)
        
        self.navigationController?.toolbarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.toolbarHidden = true
    }
    
    // MARK: IBActions
    
    @IBAction func deleteMemeBarButtonItemPressed(sender: UIBarButtonItem) {
        // Search for current meme in the memes array
        for (index, meme) in enumerate(self.sharedModel.memesArray()) {
            if meme.memeImage == self.meme.memeImage {
                // Delete Meme at current Index
                self.sharedModel.removeMemeAtIndex(index)
                
                // Dismiss Meme Detail View
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    @IBAction func editBarButtonItemPressed(sender: UIBarButtonItem) {
        let memeEditorNavController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorNavigationController") as! UINavigationController
        
        self.navigationController?.presentViewController(memeEditorNavController, animated: true, completion: nil)
    }
    
}
