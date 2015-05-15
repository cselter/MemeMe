     //
//  MemesViewTableController.swift
//  MemeMe
//
//  Created by Christopher Burgess on 5/15/15.
//  Copyright (c) 2015 Christopher Burgess. All rights reserved.
//

import Foundation
import UIKit
     
class MemesViewTableController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

     let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
     
     
     func viewDidAppear() {
     self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
     }
     
     // gets the number of items in the meme array
     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          let count = appDelegate.memes.count
          println("Count: \(count)") // debug
          return count
     }
  
     
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
          
          let meme = appDelegate.memes[indexPath.row]
          
          cell.imageView?.image = meme.memedImage
          cell.textLabel?.text = meme.topText
          
          return cell
     }

}