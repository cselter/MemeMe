//
//  MemesViewCollectionController.swift
//  MemeMe
//
//  Created by Christopher Burgess on 5/15/15.
//  Copyright (c) 2015 Christopher Burgess. All rights reserved.
//

// Tab Bar Icons designed by Freepik

import Foundation
import UIKit

class MemesViewCollectionController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {
     
     let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
     
     override func viewDidAppear(animated: Bool) {
          
          // open the Meme Editor VC if no memes exist yet
          if appDelegate.memes.count == 0
          {
               var emptyMemesAlert = UIAlertView()
               emptyMemesAlert.title = "No Memes"
               emptyMemesAlert.message = "There are no memes. Please create one!"
               emptyMemesAlert.addButtonWithTitle("OK")
               emptyMemesAlert.show()
               
               openEditor(self)
          }
     }
     
     // Reload the data each time the view is selected
     override func viewWillAppear(animated: Bool) {
          self.collectionView?.reloadData()
          self.collectionView?.backgroundColor = UIColor.whiteColor()
     }
     
     func openEditor(sender: AnyObject) {
          self.performSegueWithIdentifier("newMemeFromGrid", sender: self)
     }
     
     // gets the number of items in the meme array
     override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          let count = appDelegate.memes.count
          return count
     }
     
     // Return cell for each grid cell
     override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
          
          let meme = appDelegate.memes[indexPath.row]
          
          cell.cellImageView?.image = meme.memedImage
          
          cell.backgroundView = cell.cellImageView
          
          return cell
     }
     
     // Show Detail View when cell is selected
     override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
          let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
          
          detailController.meme = self.appDelegate.memes[indexPath.row]
          detailController.memeIndex = indexPath.row
          
          self.navigationController!.pushViewController(detailController, animated: true)
     }
     
     // edit button that allows deleting meme from collection view
     
     
}