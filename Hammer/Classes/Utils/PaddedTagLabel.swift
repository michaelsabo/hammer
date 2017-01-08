//
//  PaddedTagLabel.swift
//  Hammer
//
//  Created by Mike Sabo on 11/7/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation


class PaddedTagLabel : UILabel {
  
  let topInset: CGFloat = 2.0
  let bottomInset:CGFloat = 2.0
  let leftInset:CGFloat = 6.0
  let rightInset:CGFloat = 6.0
  
  convenience init(text: String) {
    self.init()
    self.frame.size.height = 40.0
    self.font = App.font()
    self.text = text
    self.translatesAutoresizingMaskIntoConstraints = false
    self.textColor = ColorThemes.viewTextColor()
    self.backgroundColor = ColorThemes.tagBackgroundColor()
    self.numberOfLines = 0
    self.layer.masksToBounds = true
    self.tag = 200
    self.lineBreakMode = NSLineBreakMode.byWordWrapping
    self.clipsToBounds = true
  }
  
  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    self.layer.cornerRadius = 5.0
    self.setNeedsLayout()
    return super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
  }
  
  override var intrinsicContentSize : CGSize {
    var intrinsicSuperViewContentSize = super.intrinsicContentSize
    intrinsicSuperViewContentSize.height += bottomInset + topInset
    intrinsicSuperViewContentSize.width += leftInset + rightInset
    return intrinsicSuperViewContentSize
  }
}

class PaddedButton : UIButton {

  override func layoutSubviews() {
    if var titleFrame : CGRect = titleLabel?.frame {
      titleFrame.size = self.bounds.size
      titleFrame.origin = CGPoint.zero
      self.titleLabel!.frame = titleFrame
      self.titleLabel!.textAlignment = .center
    }
  }
}



