//
//  UIExtensions.swift
//  Hammer
//
//  Created by Mike Sabo on 12/3/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation
import MMPopupView

extension UIButton {

  func newButton(withTitle title:String, target: AnyObject, selector: Selector, forControlEvent event: UIControlEvents) -> UIButton {
    self.setTitle(title, for: UIControlState())
    self.setTitleColor(ColorThemes.navigationBarIconColor(), for: UIControlState())
    self.titleLabel?.font = App.font()
    self.backgroundColor = ColorThemes.tagBackgroundColor()
    self.titleLabel?.clipsToBounds = false
   
    self.translatesAutoresizingMaskIntoConstraints = false
    self.layer.cornerRadius = 5.0
    self.addTarget(target, action: selector, for: event)
    return self
  }
  
}

extension MMAlertViewConfig {
  

  
}
