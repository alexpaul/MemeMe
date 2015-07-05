//
//  Meme.swift
//  MemeMe
//
//  Created by Alex Paul on 6/27/15.
//  Copyright (c) 2015 Alex Paul. All rights reserved.
//
//  Struct of Data Objects for MemeMe

import UIKit

struct Meme {
    var topMeme: String!
    var bottomMeme: String!
    var originalImage: UIImage!
    var memeImage: UIImage!
    
    init(topMeme: String, bottomMeme: String, originalImage: UIImage, memeImage: UIImage){
        self.topMeme = topMeme
        self.bottomMeme = bottomMeme
        self.originalImage = originalImage
        self.memeImage = memeImage
    }
}
