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
     
     var meme: Meme!
     
     override func viewWillAppear(animated: Bool) {
          self.memeImageView!.image = meme.memedImage
     }
}

