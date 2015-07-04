//
//  SettingsViewController.swift
//  MemeMe
//
//  Created by Alex Paul on 7/2/15.
//  Copyright (c) 2015 Alex Paul. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    var fonts = ["HelveticaNeue-CondensedBlack", "Verdana-Bold", "Menlo-Bold", "GillSans-Bold"]
    var defaultFont: String!
    
    // MARK: IBOutlets
    @IBOutlet weak var savePhotosSwitch: UISwitch!
    @IBOutlet var staticTableView: UITableView!
    
    // View Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get the Default font from NSUserDefaults or the MemeSharedModel
        if var font = MemeSharedModel.sharedInstance.getMemeFont() {
            self.defaultFont = font
        }
    }
    
    
    // MARK: IBActions
    
    @IBAction func doneBarButtonItemPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func savePhotosSwitchToggled(sender: UISwitch) {
        if sender.on {
            println("Save Photos to Photos Library")
        }else {
            println("Don't save Photso")
        }
    }
    
    // TODO: Save defaults to NSUserDefaults or Shared Instance
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fonts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FontCell", forIndexPath: indexPath) as! UITableViewCell
        
        let font = self.fonts[indexPath.row]
        
        cell.textLabel?.font = UIFont(name: font, size: 16.0)
        
        cell.textLabel?.text = font
        
        if font == self.defaultFont {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let fontIndex: Int = find(self.fonts, self.defaultFont)!
        // NOT Supported in Swift 2.0, use arrayName.indexOf()
        
        // Return if Font index is the same as the current selected index
        if indexPath.row == fontIndex {
            return
        }
        
        let oldIndexPath = NSIndexPath(forItem: fontIndex, inSection: 0)
        
        if var newCell = tableView.cellForRowAtIndexPath(indexPath) {
            if newCell.accessoryType == UITableViewCellAccessoryType.None {
                newCell.accessoryType = UITableViewCellAccessoryType.Checkmark
                
                // Update Default Font
                MemeSharedModel.sharedInstance.createMemeFont(self.fonts[indexPath.row])
            }
        }
        
        if var oldCell = tableView.cellForRowAtIndexPath(oldIndexPath) {
            if oldCell.accessoryType == UITableViewCellAccessoryType.Checkmark {
                oldCell.accessoryType = UITableViewCellAccessoryType.None
            }
        }

    }
    
}
