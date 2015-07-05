//
//  MemeSharedModel.swift
//  MemeMe
//
//  Created by Alex Paul on 6/27/15.
//  Copyright (c) 2015 Alex Paul. All rights reserved.
//
//  Shared Instance / Singleton for MemeMe

import UIKit

class MemeSharedModel: NSObject {
    
    var memes = [Meme]() // Meme Array
    var memeFont: String!
    var savePhotos = false
    var croppingAllowed = false
    
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
    
    func memesArray() -> [Meme] {
        return memes
    }
    
    func removeMemeAtIndex(index: Int) {
        memes.removeAtIndex(index)
    }
    
    func getMemeFont() -> String? {
        return memeFont
    }
    
    func createMemeFont(memeFont: String) {
        self.memeFont = memeFont
    }
    
    func savePhotosToThePhotoLibrary(savePhotos: Bool) {
        self.savePhotos = savePhotos
    }
    
    func shouldPhotosBeSavedToPhotoLibrary() -> Bool {
        return savePhotos
    }
    
    func isCroppingAllowed() -> Bool {
        return croppingAllowed
    }
    
    func croppingIsAllowed(croppingAllowed: Bool) {
        self.croppingAllowed = croppingAllowed
    }
   
}
    