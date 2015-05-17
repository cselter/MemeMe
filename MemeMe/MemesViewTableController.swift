//
//  MemesViewTableController.swift
//  MemeMe
//
//  Created by Christopher Burgess on 5/15/15.
//  Copyright (c) 2015 Christopher Burgess. All rights reserved.
//

import Foundation
import UIKit
     
class MemesViewTableController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
     
     let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
     
     // Lower the top of the table view
     func viewDidAppear() {
          self.tableView!.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
     }
     
     // Reload the data each time the view is selected
     override func viewWillAppear(animated: Bool) {
          self.tableView?.reloadData()
     }
     
     // gets the number of items in the meme array
     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          let count = appDelegate.memes.count
          return count
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
          
          self.navigationController?.pushViewController(detailController, animated: true)
     }
}