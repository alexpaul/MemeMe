//
//  MemeSharedModel.swift
//  MemeMe
//
//  Created by Alex Paul on 6/27/15.
//  Copyright (c) 2015 Alex Paul. All rights reserved.
//

import UIKit

class MemeSharedModel: NSObject {
    
    var memes = [Meme]() // Meme Array
    
    class var sharedInstance: MemeSharedModel {
        struct Static {
            static let instance: MemeSharedModel = MemeSharedModel()
        }
        return Static.instance
    }
    
    func addMemes(meme: Meme) {
        memes.append(meme)
    }
    
    func memesCount() -> Int {
        return memes.count
    }
   
}
    