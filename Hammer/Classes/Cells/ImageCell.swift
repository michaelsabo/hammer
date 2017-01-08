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
    self.contentView.backgroundColor = UIColor.clear
    self.isUserInteractionEnabled = false
  }
  
  func setImage(_ data: Data?) {
    if let imageData = data {
      if let image = UIImageJPEGRepresentation(UIImage(data: imageData)!, 0.1) {
        self.imageView.image = UIImage(data: image)
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 10.0
        self.imageView.layer.borderWidth = 0.6
        self.imageView.layer.borderColor = ColorThemes.getOutlineColor().cgColor
        hasLoaded = true
        self.isUserInteractionEnabled = true
      }
    }
  }	
}
