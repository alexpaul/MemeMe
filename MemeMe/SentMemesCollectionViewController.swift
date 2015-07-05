//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Alex Paul on 6/28/15.
//  Copyright (c) 2015 Alex Paul. All rights reserved.
//
//  Collection View of Sent Memes

import UIKit

class SentMemesCollectionViewController: UIViewController,
                            UICollectionViewDelegate, UICollectionViewDataSource {
    
    var meme: Meme!
    var sharedModel: MemeSharedModel!
    
    // MARK: IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sent Memes Collection"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addBarButtonItemPressed:")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.sharedModel = MemeSharedModel.sharedInstance
        self.collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sharedModel.memesCount()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        let meme = self.sharedModel.memesArray()[indexPath.item]
        
        cell.memeImageView.image = meme.memeImage
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate Methods
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let meme = self.sharedModel.memesArray()[indexPath.item]
        
        let memeDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        memeDetailViewController.meme = meme
        memeDetailViewController.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
    
    // MARK: Helper Methods
    
    func addBarButtonItemPressed(sender: UIBarButtonItem) {
        let memeEditorNC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorNavigationController") as! UINavigationController
        self.navigationController?.presentViewController(memeEditorNC, animated: true, completion: nil)
    }
}
