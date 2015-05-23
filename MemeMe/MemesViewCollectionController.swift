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

     @IBOutlet weak var memeCV: UICollectionView!
     @IBOutlet weak var editButton: UIBarButtonItem!
     @IBOutlet weak var addDeleteButton: UIBarButtonItem!
     @IBOutlet weak var navBar: UINavigationItem!
     
     var editItems = false
     var selectedItems = Set<NSIndexPath>()
     
     override func viewDidLoad() {
          memeCV.allowsMultipleSelection = true
     }
     
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
     
     // open the editor VC to create a new meme
     @IBAction func openEditor(sender: AnyObject) {
          
          if self.editItems
          {
              println("No Way Jose! You're editing!")
          }
          else {
               self.performSegueWithIdentifier("newMemeFromGrid", sender: self)
          }
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
          
          if self.selectedItems.contains(indexPath) {
               cell.isSelected(true)
          }
          else {
               cell.isSelected(false)
          }
          
          return cell
     }
     
     // Show Detail View when cell is selected
     override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
          
          // if editing is enabled
          if self.editItems {
               
               self.navBar.rightBarButtonItem?.enabled = true
               let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MemeCollectionViewCell

               cell.isSelected(true)
               self.selectedItems.insert(indexPath)
          }
          // otherwise view selected meme
          else {
               let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
          
               detailController.meme = self.appDelegate.memes[indexPath.row]
               detailController.memeIndex = indexPath.row
          
               self.navigationController!.pushViewController(detailController, animated: true)
          }
     }
     
     // when a cell item is deselected
     override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
          
          if self.editItems {
               
               if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MemeCollectionViewCell {
                    cell.isSelected(false)
               }
               
               self.selectedItems.remove(indexPath)
               
               self.navBar.rightBarButtonItem?.enabled = (selectedItems.count > 0)
          }
     }
     
     // edit button that allows deleting meme from collection view
     @IBAction func editButtonSelected(sender: AnyObject) {
         
          self.editItems = !self.editItems
          
          if self.editItems {
               // Edit pressed
               editButton.title = "Done"
               
               let deleteButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "deleteMemesAlert:")
               
               navBar.rightBarButtonItem = deleteButton
               // intially disable trash button until at least one item is selected
               navBar.rightBarButtonItem?.enabled = false
          }
          else {
               // Done pressed
               editButton.title = "Edit"
               
               // deselect everything still selected
               for indexPath in self.selectedItems {
                    self.memeCV.deselectItemAtIndexPath(indexPath, animated: false)
                    
                    if let cell = self.memeCV.cellForItemAtIndexPath(indexPath) as? MemeCollectionViewCell {
                         cell.isSelected(false)
                    }
               }
               self.selectedItems.removeAll(keepCapacity: false)
               
               // update the action item back to Add Meme
               let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "openEditor:")
               navBar.rightBarButtonItem = addButton
          }
     }
     
     // give the user an alert asking to confirm delete
     func deleteMemesAlert(sender: AnyObject) {
          if selectedItems.count > 0 {
               let deleteAlert = UIAlertController()
               deleteAlert.title = "Are you sure you want to delete these AWESOME memes?!"
               
               let deleteThem = UIAlertAction(title: "Delete them!", style: UIAlertActionStyle.Destructive) {
                    action in self.deleteSelectedMemes(self)
               }
               
               let keepThem = UIAlertAction(title: "NO! Keep them!", style: UIAlertActionStyle.Destructive) {
                    action in self.dismissViewControllerAnimated(true, completion: nil)
               }
               
               deleteAlert.addAction(deleteThem)
               deleteAlert.addAction(keepThem)
               
               self.presentViewController(deleteAlert, animated: true, completion: nil)
          }
     }
     
     // delete all memes that are currently selected
     func deleteSelectedMemes(sender: AnyObject) {
          if selectedItems.count > 0 {
               var arrayOfMemeIndexPathsToDelete = Array(self.selectedItems)
               
               arrayOfMemeIndexPathsToDelete.sort {
                    (indexPath1 : NSIndexPath, indexPath2: NSIndexPath) -> Bool in return indexPath1.item > indexPath2.item
               }
               
               for indexPath in arrayOfMemeIndexPathsToDelete {
                    appDelegate.memes.removeAtIndex(indexPath.item)
               }
               
               self.selectedItems.removeAll(keepCapacity: false)
               
               // reload the view
               self.collectionView?.reloadData()
               self.navBar.rightBarButtonItem?.enabled = (selectedItems.count > 0)
          }
     }
}