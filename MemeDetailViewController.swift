//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Christopher Burgess on 5/17/15.
//  Copyright (c) 2015 Christopher Burgess. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController
{
     @IBOutlet weak var memeImageView: UIImageView!

     @IBOutlet weak var editButton: UIBarButtonItem!
     @IBOutlet weak var deleteButton: UIBarButtonItem!
     
     var meme: Meme!
     var memeIndex: Int!
     
     override func viewWillAppear(animated: Bool) {
          self.memeImageView!.image = meme.memedImage
          deleteButton.enabled = true
     }
     
     // Delete a Meme from the Detail View
     @IBAction func deleteMeme(sender: AnyObject) {
          let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
          
          appDelegate.memes.removeAtIndex(memeIndex)
          deleteButton.enabled = false
          
          self.navigationController?.popViewControllerAnimated(true)
     }
     
     @IBAction func editMeme(sender: AnyObject) {
          
          var editVC:EditorViewController
          editVC = self.storyboard?.instantiateViewControllerWithIdentifier("EditorViewController") as! EditorViewController
          
          editVC.isEdit = true
          editVC.editMeme = self.meme
          
          
          
          self.presentViewController(editVC, animated: true, completion: nil)
     }

}

