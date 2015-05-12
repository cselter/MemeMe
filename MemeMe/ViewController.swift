//
//  ViewController.swift
//  MemeMe
//
//  Created by Christopher Burgess on 5/12/15.
//  Copyright (c) 2015 Christopher Burgess. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
     
     @IBOutlet weak var selectedImageView: UIImageView!
     @IBOutlet weak var cameraButton: UIBarButtonItem!
     @IBOutlet weak var shareButton: UIBarButtonItem!
     @IBOutlet weak var resetButton: UIBarButtonItem!
     
     @IBOutlet weak var topTextField: UITextField!
     @IBOutlet weak var bottomTextField: UITextField!
     @IBOutlet weak var topToolbar: UIToolbar!
     @IBOutlet weak var bottomToolbar: UIToolbar!
     
     let memeTextAttributes = [
          NSStrokeColorAttributeName : UIColor.blackColor(),
          NSForegroundColorAttributeName : UIColor.whiteColor(),
          NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
          NSStrokeWidthAttributeName : -3.0
     ]
     
     override func viewWillAppear(animated: Bool) {
          cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
          
          self.subscribeToKeyboardNotifications()
          
          
     }
     
     override func viewWillDisappear(animated: Bool) {
          self.unsubscribeFromKeyboardNotifications()
          
     }
     
     override func viewDidLoad() {
          super.viewDidLoad()
          // Do any additional setup after loading the view, typically from a nib.
          
          topTextField.text = "TOP"
          bottomTextField.text = "BOTTOM"
          
          topTextField.delegate = self
          bottomTextField.delegate = self

          topTextField.defaultTextAttributes = memeTextAttributes
          bottomTextField.defaultTextAttributes = memeTextAttributes
          
          topTextField.textAlignment = NSTextAlignment.Center
          bottomTextField.textAlignment = NSTextAlignment.Center
          
          shareButton.enabled = false
          resetButton.enabled = false
     }
     
     override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
          // Dispose of any resources that can be recreated.
     }
     
     // Select image from photo library to use
     @IBAction func pickImage(sender: AnyObject) {
          let pickerController = UIImagePickerController()
          pickerController.delegate = self
          pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
          self.presentViewController(pickerController, animated: true, completion: nil)
          
          shareButton.enabled = true
          resetButton.enabled = true
     }
     
     // Select image from camera
     @IBAction func pickAnImageFromCamera (sender: AnyObject) {
          let imagePicker = UIImagePickerController()
          imagePicker.delegate = self
          imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
          self.presentViewController(imagePicker, animated: true, completion: nil)
          
          
          
     }
     
     func imagePickerController(picker: UIImagePickerController,
          didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
               
               if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    self.selectedImageView.image = image
               }
               self.dismissViewControllerAnimated(true, completion: nil)
               
               
     }
     
     // Dismisses image picker when user selects cancel
     func imagePickerControllerDidCancel(picker: UIImagePickerController) {
          
          self.dismissViewControllerAnimated(true, completion: nil)
     }
     
     // Clears default text when user starts editing
     func textFieldDidBeginEditing(textField: UITextField) {
          if topTextField.text == "TOP" {
               topTextField.text = ""
          }
          
          if bottomTextField.text == "BOTTOM" {
               bottomTextField.text = ""
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
               self.view.frame.origin.y += getKeyboardHeight(notification)
          }
     }
     
     func generateMemedImage() -> UIImage {
          
          // TODO: Hide toolbar and navbar
          topToolbar.alpha = 0
          bottomToolbar.alpha = 0
          
          // Render view to an image
          UIGraphicsBeginImageContext(self.view.frame.size)
          self.view.drawViewHierarchyInRect(self.view.frame,
               afterScreenUpdates: true)
          let memedImage : UIImage =
          UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          
          // TODO:  Show toolbar and navbar
          topToolbar.alpha = 1
          bottomToolbar.alpha = 1
          
          return memedImage
     }
     
     func save() {
          //Create the meme
          var meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image:
               selectedImageView.image!, memedImage: self.generateMemedImage())
          
          // Save to camera roll
          UIImageWriteToSavedPhotosAlbum(generateMemedImage(), nil, nil, nil)
          
          // Add it to the memes array in the Application Delegate
          (UIApplication.sharedApplication().delegate as!
               AppDelegate).memes.append(meme)
     }
     
     @IBAction func saveButtonPressed(sender: AnyObject) {
          save()
     }
     
     // reset the fields and image view for a new meme
     @IBAction func resetEditor(sender: AnyObject) {
          topTextField.text = "TOP"
          bottomTextField.text = "BOTTOM"
          selectedImageView.image = nil
          shareButton.enabled = false
          resetButton.enabled = false
     }
     
     
}

