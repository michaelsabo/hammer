//
//  ImageCell.swift
//  Hammer
//
//  Created by Mike Sabo on 10/4/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
	@IBOutlet weak var imageView: UIImageView!
	
	var hasLoaded = false
	
	
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }
	
  func initialize() {
    self.contentView.layer.masksToBounds = true
    self.contentView.backgroundColor = UIColor.clearColor()
    self.userInteractionEnabled = false
  }
  
  func setImage(image: NSData?) {
    if let data = image {
      self.imageView.image = UIImage(data: data)
      self.imageView.layer.masksToBounds = true
      self.imageView.layer.cornerRadius = 10.0
      hasLoaded = true
      self.userInteractionEnabled = true
    }

  }
	
}
