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

extension ImageCell {
  
  func animateFromLeft(completion: @escaping () -> Void) {
    self.imageView.transform = CGAffineTransform(translationX: -20, y: 0)
    UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2, animations: { [weak self] in
        self?.imageView.transform = CGAffineTransform(translationX: -15, y: 0)
      })
      UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.2, animations: { [weak self] in
        self?.imageView.transform = CGAffineTransform(translationX: -9, y: 0)
      })
      UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2, animations: { [weak self] in
        self?.imageView.transform = CGAffineTransform(translationX: -6, y: 0)
      })
      UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.1, animations: { [weak self] in
        self?.imageView.transform = CGAffineTransform(translationX: 0, y: 0)
      })
      }, completion: { (finished: Bool) in
        completion()
    })
  }
  
  func scaleToFullSize(completion: @escaping () -> Void) {
    self.imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    
    UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1, animations: { [weak self] in
        self?.imageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
      })
      UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.2, animations: { [weak self] in
        self?.imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
      })
      UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.2, animations: { [weak self] in
        self?.imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
      })
      }, completion: { (finished: Bool) in
        completion()
    })
  }
  
  func animateFromRight(completion: @escaping () -> Void) {
    self.imageView.transform = CGAffineTransform(translationX: 20, y: 0)
    UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1, animations: { [weak self] in
        self?.imageView.transform = CGAffineTransform(translationX: 15, y: 0)
      })
      UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.1, animations: { [weak self] in
        self?.imageView.transform = CGAffineTransform(translationX: 9, y: 0)
      })
      UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.1, animations: { [weak self] in
        self?.imageView.transform = CGAffineTransform(translationX: 6, y: 0)
      })
      UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.2, animations: { [weak self] in
        self?.imageView.transform = CGAffineTransform(translationX: 0, y: 0)
      })
      }, completion: { (finished: Bool) in
        completion()
    })

  }
  
}
