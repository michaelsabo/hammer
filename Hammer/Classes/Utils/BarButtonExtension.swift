//
//  BarButtonExtension.swift
//  Hammer
//
//  Created by Mike Sabo on 1/23/16.
//  Copyright © 2016 FlyingDinosaurs. All rights reserved.
//

import Foundation
import Font_Awesome_Swift

extension UIBarButtonItem {
  
  func setup(target target:AnyObject, icon: FAType, action:Selector) -> UIBarButtonItem {
    self.target = target
    self.FAIcon = icon
    self.action = action
    return self
  }
  
}
