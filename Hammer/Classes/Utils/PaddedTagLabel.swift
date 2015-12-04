//
//  PaddedTagLabel.swift
//  Hammer
//
//  Created by Mike Sabo on 11/7/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation


class PaddedTagLabel : UILabel {
  
  let topInset: CGFloat = 6.0
  let bottomInset:CGFloat = 6.0
  let leftInset:CGFloat = 6.0
  let rightInset:CGFloat = 6.0
  
  convenience init(text: String) {
    self.init()
    self.font = App.font()
    self.text = text
    self.translatesAutoresizingMaskIntoConstraints = false
    self.textColor = UIColor.flatWhiteColor()
    self.backgroundColor = UIColor.flatTealColor()
    self.numberOfLines = 0
    self.layer.masksToBounds = true
    self.tag = 200
    self.lineBreakMode = NSLineBreakMode.ByWordWrapping
  }
  
  override func drawTextInRect(rect: CGRect) {
    let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    self.layer.cornerRadius = 5.0
    self.setNeedsLayout()
    return super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
  }
  
  override func intrinsicContentSize() -> CGSize {
    var intrinsicSuperViewContentSize = super.intrinsicContentSize()
    intrinsicSuperViewContentSize.height += bottomInset + topInset
    intrinsicSuperViewContentSize.width += leftInset + rightInset
    return intrinsicSuperViewContentSize
  }
  
  
}