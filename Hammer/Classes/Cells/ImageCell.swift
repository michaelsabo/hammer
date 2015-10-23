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
	
	init(_ coder: NSCoder? = nil) {
		
		
		if let coder = coder {
			super.init(coder: coder)!
		} else {
			super.init()
		}
		self.contentView.layer.masksToBounds = true
		self.contentView.backgroundColor = UIColor.clearColor()
		
	}
	
	required convenience init(coder: NSCoder) {
		self.init(coder)
	}
	
	
}
