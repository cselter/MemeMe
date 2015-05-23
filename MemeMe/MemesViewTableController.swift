//
//  MemesViewTableController.swift
//  MemeMe
//
//  Created by Christopher Burgess on 5/15/15.
//  Copyright (c) 2015 Christopher Burgess. All rights reserved.
//

// Tab Bar Icons designed by Freepik

import Foundation
import UIKit
     
class MemesViewTableController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
     
     @IBOutlet weak var editButton: UIBarButtonItem!
     var noMemeAlertShown = false
     
     let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

     override func viewDidAppear(animated: Bool) {
          
          // open the Meme Editor VC if no memes exist yet
          if appDelegate.memes.count == 0 && noMemeAlertShown == false
          {
               var emptyMemesAlert = UIAlertView()
               emptyMemesAlert.title = "No Memes"
               emptyMemesAlert.message = "There are no memes. Please create one!"
               emptyMemesAlert.addButtonWithTitle("OK")
               emptyMemesAlert.show()
               
               noMemeAlertShown = true
               openEditor(self)
          }
     }
     
     // Reload the data each time the view is selected
     override func viewWillAppear(animated: Bool) {
          super.viewWillAppear(animated)
          self.tableView?.reloadData()
          self.editButton.enabled = (appDelegate.memes.count > 0)
     }
     
     @IBAction func openEditor(sender: AnyObject) {
          self.performSegueWithIdentifier("newMemeFromTable", sender: self)
     }
     
     // gets the number of items in the meme array
     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return appDelegate.memes.count
     }
  
     // Return cell for each grid row
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell", forIndexPath: indexPath) as! UITableViewCell
          let memeCell = appDelegate.memes[indexPath.row]
          cell.imageView?.image = memeCell.memedImage
          cell.textLabel?.text = memeCell.topText
    
          return cell
     }
     
     // Show Detail View when row is selected
     override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
          let detailController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
          detailController.meme = self.appDelegate.memes[indexPath.row]
          detailController.memeIndex = indexPath.row
          
          self.navigationController?.pushViewController(detailController, animated: true)
     }
     
     // Delete a meme
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  
          switch editingStyle {
               case .Delete:
                    // Delete the meme from the model
                    appDelegate.memes.removeAtIndex(indexPath.row)

                    // remove row and refresh local data
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)

               default:
                    return
          }
     }
     
     // edit button that allows deleting memes from table view
     @IBAction func editButtonSelected(sender: AnyObject) {
          
          // Alternate Editing State of TableView
          let currState = self.tableView.editing
          let nextState = !currState
          
          self.tableView.setEditing(nextState, animated: true)
          
          if nextState {
               editButton.title = "Done"
          }
          else {
               editButton.title = "Edit"
               editButton.enabled = (appDelegate.memes.count > 0)
          }
     }
}