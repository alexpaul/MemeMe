//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Alex Paul on 6/28/15.
//  Copyright (c) 2015 Alex Paul. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // Instance Variables
    var sharedModel: MemeSharedModel!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sent Memes Table"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.sharedModel = MemeSharedModel.sharedInstance
        self.tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sharedModel.memesArray().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        
        let meme = self.sharedModel.memesArray()[indexPath.row]
        
        var topLabel = cell.viewWithTag(2) as! UILabel
        var bottomLabel = cell.viewWithTag(3) as! UILabel
        var imageView = cell.viewWithTag(1) as! UIImageView
        
        topLabel.text = meme.topMeme
        bottomLabel.text = meme.bottomMeme
        imageView.image = meme.memeImage
                
        return cell
    }
    
    // MARK: UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let meme = self.sharedModel.memesArray()[indexPath.row]
        
        let memeDetailVC = MemeDetailViewController()
        memeDetailVC.meme = meme
        memeDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(memeDetailVC, animated: true)
    }
    
    // MARK: IBActions
    
    @IBAction func addBarButtonItemPressed(sender: UIBarButtonItem) {
        let memeEditorNC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorNavigationController") as! UINavigationController
        self.navigationController?.presentViewController(memeEditorNC, animated: true, completion: nil)
    }
    
    
}