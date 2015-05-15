//
//  Meme.swift
//  MemeMe
//
//  Created by Christopher Burgess on 5/12/15.
//  Copyright (c) 2015 Christopher Burgess. All rights reserved.
//

import Foundation
import UIKit

class Meme {
     var topText: String?
     var bottomText: String?
     var image: UIImage?
     var memedImage: UIImage?
     
     init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage) {
          self.topText = topText
          self.bottomText = bottomText
          self.image = image
          self.memedImage = memedImage
     }
}