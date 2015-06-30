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
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    
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
        
        println("there are \(self.sharedModel.memesCount()) meemes")
        
        if self.sharedModel.memesCount() > 0 {
            self.navigationItem.leftBarButtonItem = self.editButtonItem()
        }else{
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    // MARK: UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sharedModel.memesCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! MemeTableViewCell
        
        let meme = self.sharedModel.memesArray()[indexPath.row]
        
        cell.memeImageView.image = meme.memeImage
        cell.topMemeLabel.text = meme.topMeme
        cell.bottomMemeLabel.text = meme.bottomMeme
        
        return cell
    }
    
    // MARK: Delete
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: true)
        if editing{
            self.addBarButtonItem.enabled = false
        }else{
            self.addBarButtonItem.enabled = true
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.sharedModel.removeMemeAtIndex(indexPath.row) // Remove from Data Source
            self.tableView.reloadData() // Update Table View
        }
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
