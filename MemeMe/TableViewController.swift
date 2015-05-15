//
//  TableViewController.swift
//  MemeMe
//
//  Created by Christopher Burgess on 5/12/15.
//  Copyright (c) 2015 Christopher Burgess. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
     
     let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
     
     
     
     var memes: [memes]
     
     @IBOutlet weak var tableView: UITableView!
     
     
}