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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the image view
        let statusBarPlusNavBarHeight: CGFloat = 64
        self.imageView = UIImageView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + statusBarPlusNavBarHeight,
            width: self.view.frame.width, height: self.view.frame.height - statusBarPlusNavBarHeight))
        self.imageView.image = self.meme.memeImage
        self.view.addSubview(self.imageView)
    }

}
