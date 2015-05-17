//
//  MemesViewCollectionController.swift
//  MemeMe
//
//  Created by Christopher Burgess on 5/15/15.
//  Copyright (c) 2015 Christopher Burgess. All rights reserved.
//

import Foundation
import UIKit

class MemesViewCollectionController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {
     
     let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
     
     func viewDidAppear() {
          self.collectionView!.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
     }
     
     override func viewWillAppear(animated: Bool) {
          self.collectionView?.reloadData()
          self.collectionView?.backgroundColor = UIColor.whiteColor()
     }
     
     // gets the number of items in the meme array
     override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          let count = appDelegate.memes.count
          return count
     }
     
     override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
          
          let meme = appDelegate.memes[indexPath.row]
          
          cell.cellImageView?.image = meme.memedImage
          
          cell.backgroundView = cell.cellImageView
          
          return cell
     }
     
     override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
          let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
          
          detailController.meme = self.appDelegate.memes[indexPath.row]
          
          self.navigationController!.pushViewController(detailController, animated: true)
     }
}