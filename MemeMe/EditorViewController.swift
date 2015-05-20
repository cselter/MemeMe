//
//  EditorViewController.swift
//  MemeMe
//
//  Created by Christopher Burgess on 5/12/15.
//  Copyright (c) 2015 Christopher Burgess. All rights reserved.
//

// Tab Bar Icons designed by Freepik

import UIKit

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
     
     @IBOutlet weak var selectedImageView: UIImageView!
     @IBOutlet weak var cameraButton: UIBarButtonItem!
     @IBOutlet weak var shareButton: UIBarButtonItem!
     @IBOutlet weak var resetButton: UIBarButtonItem!
     
     @IBOutlet weak var topTextField: UITextField!
     @IBOutlet weak var bottomTextField: UITextField!
     @IBOutlet weak var topToolbar: UIToolbar!
     @IBOutlet weak var bottomToolbar: UIToolbar!
     
     var isEdit = false
     
     var editMeme: Meme!
     
     let memeTextAttributes = [
          NSStrokeColorAttributeName : UIColor.blackColor(),
          NSForegroundColorAttributeName : UIColor.whiteColor(),
          NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
          NSStrokeWidthAttributeName : -3.0
     ]
     
     override func prefersStatusBarHidden() -> Bool {
          return true
     }
     
     override func viewWillAppear(animated: Bool) {
          cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
          
          self.subscribeToKeyboardNotifications()
     }
     
     override func viewWillDisappear(animated: Bool) {
          self.unsubscribeFromKeyboardNotifications()
     }
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          if isEdit == true {
               
               self.topTextField.text = editMeme.topText
               self.bottomTextField.text = editMeme.bottomText
               self.selectedImageView.image = editMeme.image
               shareButton.enabled = true
          }
          
          topTextField.delegate = self
          bottomTextField.delegate = self

          topTextField.defaultTextAttributes = memeTextAttributes
          bottomTextField.defaultTextAttributes = memeTextAttributes
          
          topTextField.textAlignment = NSTextAlignment.Center
          bottomTextField.textAlignment = NSTextAlignment.Center
          
          if isEdit == false
          {
               shareButton.enabled = false
          }
          
     }
     
     // Select image from photo library to use
     @IBAction func pickImage(sender: AnyObject) {
          let pickerController = UIImagePickerController()
          pickerController.delegate = self
          pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
          self.presentViewController(pickerController, animated: true, completion: nil)
     }
     
     // Select image from camera
     @IBAction func pickAnImageFromCamera (sender: AnyObject) {
          let imagePicker = UIImagePickerController()
          imagePicker.delegate = self
          imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
          self.presentViewController(imagePicker, animated: true, completion: nil)
     }
     
     // Dismisses image picker when image is selected from camera or library
     func imagePickerController(picker: UIImagePickerController,
          didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
               
               if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    self.selectedImageView.image = image
               }
               self.dismissViewControllerAnimated(true, completion: nil)
               
               shareButton.enabled = true
     }
     
     // Dismisses image picker when user selects cancel
     func imagePickerControllerDidCancel(picker: UIImagePickerController) {
          
          self.dismissViewControllerAnimated(true, completion: nil)
     }
     
     // Clears default text when user starts editing
     func textFieldDidBeginEditing(textField: UITextField) {
          
          if isEdit == false {
               if topTextField.text == "TOP" {
                    topTextField.text = ""
               }
               
               if bottomTextField.text == "BOTTOM" {
                    bottomTextField.text = ""
               }
          }

          resetButton.enabled = true
     }
     
     // Replaces default text if user leaves blank
     // User can keep blank by entering one space
     func textFieldDidEndEditing(textField: UITextField) {
          if topTextField.text == "" {
               topTextField.text = "TOP"
          }
          
          if bottomTextField.text == "" {
               bottomTextField.text = "BOTTOM"
          }
     }
     
     // Dismisses keyboard when return is pressed
     func textFieldShouldReturn(textField: UITextField) -> Bool {
          topTextField.resignFirstResponder()
          bottomTextField.resignFirstResponder()
          return true
     }
     
     // keyboard notifications, show/hide
     func subscribeToKeyboardNotifications() {
          NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
          NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
     }
     
     func unsubscribeFromKeyboardNotifications() {
          NSNotificationCenter.defaultCenter().removeObserver(self, name:
               UIKeyboardWillShowNotification, object: nil)
          NSNotificationCenter.defaultCenter().removeObserver(self, name:
               UIKeyboardWillHideNotification, object: nil)
     }
     
     func keyboardWillShow(notification: NSNotification) {
          if bottomTextField.isFirstResponder() {
               self.view.frame.origin.y -= getKeyboardHeight(notification)
          }
     }
     
     func getKeyboardHeight(notification: NSNotification) -> CGFloat {
          let userInfo = notification.userInfo
          let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
          return keyboardSize.CGRectValue().height
     }
     
     func keyboardWillHide(notification: NSNotification) {
          if bottomTextField.isFirstResponder() {
               self.view.frame.origin.y = 0
          }
     }
     
     // create the meme
     func generateMemedImage() -> UIImage {
          // Hide toolbar and navbar
          topToolbar.alpha = 0
          bottomToolbar.alpha = 0
          
          // Render view to an image
          UIGraphicsBeginImageContext(self.view.frame.size)
          self.view.drawViewHierarchyInRect(self.view.frame,
               afterScreenUpdates: true)
          let memedImage : UIImage =
          UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          
          // Show toolbar and navbar
          topToolbar.alpha = 1
          bottomToolbar.alpha = 1
          
          return memedImage
     }
     
     // save the meme!
     func save() {
          //Create the meme
          var meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image:
               selectedImageView.image!, memedImage: self.generateMemedImage())
          
          // Add it to the memes array in the Application Delegate
          (UIApplication.sharedApplication().delegate as!
               AppDelegate).memes.append(meme)
          
          self.dismissViewControllerAnimated(true, completion: nil)
          
          let topTextFieldSaved = (UIApplication.sharedApplication().delegate as!
               AppDelegate).memes[0].topText
     }
     
     // launches Activity View Controller
     @IBAction func share(sender: AnyObject) {
          
          let completedMeme = generateMemedImage()
          
          let activityVC = UIActivityViewController(activityItems: [completedMeme], applicationActivities: nil)
          
          activityVC.completionWithItemsHandler = {
               (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
               if ok {
                    self.save()
               }
          }
          
          self.presentViewController(activityVC, animated: true, completion: nil)
     }
     
     // reset the fields and image view for a new meme & dismisses view
     @IBAction func resetEditor(sender: AnyObject) {
          topTextField.text = "TOP"
          bottomTextField.text = "BOTTOM"
          selectedImageView.image = nil
          shareButton.enabled = false
          resetButton.enabled = false
          
          self.dismissViewControllerAnimated(true, completion: nil)
     }
}

