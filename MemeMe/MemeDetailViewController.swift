//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Alex Paul on 6/28/15.
//  Copyright (c) 2015 Alex Paul. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: Meme!
    var imageView: UIImageView!
    var deleteButton: UIButton!
    var sharedModel: MemeSharedModel!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sharedModel = MemeSharedModel.sharedInstance
        
        // Configure the image view
        let statusBarPlusNavBarHeight: CGFloat = 64
        self.imageView = UIImageView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + statusBarPlusNavBarHeight,
            width: self.view.frame.width, height: self.view.frame.height - statusBarPlusNavBarHeight))
        self.imageView.image = self.meme.memeImage
        self.imageView.contentMode = UIViewContentMode.ScaleToFill
        self.view.addSubview(self.imageView)
        
        // Configure Delete Button 
        var deleteButtonWidth: CGFloat = 200
        deleteButton = UIButton(frame: CGRect(x: self.view.center.x - (deleteButtonWidth/2), y: self.view.frame.height - 80, width: deleteButtonWidth, height: 44))
        deleteButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        deleteButton.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
        deleteButton.setTitle("Delete Meme", forState: UIControlState.Normal)
        //deleteButton.sizeToFit()
        deleteButton.addTarget(self, action: "deleteButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(deleteButton)
    }
    
    // MARK: Helper Methods
    
    func deleteButtonPressed() {
        for (index, meme) in enumerate(self.sharedModel.memesArray()) {
            if meme.memeImage == self.meme.memeImage {
                // Delete Meme at current Index 
                self.sharedModel.removeMemeAtIndex(index)
                
                // Dismiss Meme Detail View
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }

}
