//
//  UIExtensions.swift
//  Hammer
//
//  Created by Mike Sabo on 12/3/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation

extension UIButton {

  func newButton(withTitle title:String, target: AnyObject, selector: Selector, forControlEvent event: UIControlEvents) -> UIButton {
    self.setTitle(title, forState: .Normal)
    self.setTitleColor(UIColor.flatWhiteColor(), forState: .Normal)
    self.titleLabel?.font = App.font()
    self.backgroundColor = UIColor.flatTealColor()
    self.contentEdgeInsets = UIEdgeInsets(top: 6.0, left: 6.0, bottom: 6.0, right: 6.0)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.layer.cornerRadius = 5.0
    self.addTarget(target, action: selector, forControlEvents: event)
    return self
  }
  
}