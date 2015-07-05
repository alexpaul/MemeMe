//
//  SettingsViewController.swift
//  MemeMe
//
//  Created by Alex Paul on 7/2/15.
//  Copyright (c) 2015 Alex Paul. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    // MARK: Instance Variables 
    
    var fonts = ["HelveticaNeue-CondensedBlack", "STHeitiSC-Medium", "AmericanTypewriter-CondensedBold", "TimesNewRomanPS-BoldMT", "Impact"]
    var defaultFont: String!
    var cell = UITableViewCell()
    var savePhotosSwitch: UISwitch!
    
    
    // View Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get the Default font from NSUserDefaults or the MemeSharedModel
        if var font = MemeSharedModel.sharedInstance.getMemeFont() {
            self.defaultFont = font
        }
        
        // Set the Save Photos Switch 
        //self.savePhotosSwitch.on = MemeSharedModel.sharedInstance.shouldPhotosBeSavedToPhotoLibrary()
    }
    
    // MARK: IBActions
    
    @IBAction func doneBarButtonItemPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let FontCell = tableView.dequeueReusableCellWithIdentifier("FontCell") as! UITableViewCell
        let SavePhotosCell = tableView.dequeueReusableCellWithIdentifier("SavePhotosCell") as! UITableViewCell
        
        var rowCount = 0
        
        if section == 0 {
            // Return Font count if Font Cell
            rowCount = self.fonts.count

        }else if section == 1 {
            // Return 1 if Save Photos Cell
            rowCount = 1
        }
        
        return rowCount
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let FontCell = tableView.dequeueReusableCellWithIdentifier("FontCell", forIndexPath: indexPath) as! UITableViewCell
            
            let font = self.fonts[indexPath.row]
            
            FontCell.textLabel?.font = UIFont(name: font, size: 20.0)
            FontCell.textLabel?.text = font
            
            if font == self.defaultFont {
                FontCell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            self.cell = FontCell
            
        } else if indexPath.section == 1 {
            let SavePhotosCell = tableView.dequeueReusableCellWithIdentifier("SavePhotosCell", forIndexPath: indexPath) as! UITableViewCell
            
            // Configure a UISwitch
            self.savePhotosSwitch = UISwitch(frame: CGRect(x: 80, y: 0, width: 20, height: 20))
            self.savePhotosSwitch.on = MemeSharedModel.sharedInstance.shouldPhotosBeSavedToPhotoLibrary()
            self.savePhotosSwitch.addTarget(self, action: "savePhotosSwitchEventTriggered", forControlEvents: UIControlEvents.ValueChanged | UIControlEvents.TouchDragInside)
            
            SavePhotosCell.textLabel?.text = "Save Photos to Photo Library"
            SavePhotosCell.accessoryView = self.savePhotosSwitch
            
            self.cell = SavePhotosCell
        }
        return self.cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // ONLY if this is the Fonts Section
        if indexPath.section == 0 {
            
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
        }else if indexPath.section == 1 {
            // Do nothing for now
        }

    }
    
    // MARK: Helper Methods 
    
    func savePhotosSwitchEventTriggered() {
        if self.savePhotosSwitch.on {
            // Save Photos to the User's Photo Library
            MemeSharedModel.sharedInstance.savePhotosToThePhotoLibrary(true)
        }else{
            // Do NOT Save ANY Photos to the Photo Library
            MemeSharedModel.sharedInstance.savePhotosToThePhotoLibrary(false)
        }
    }
    
}
