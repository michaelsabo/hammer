//
//  UIViewExtension.swift
//  Hammer
//
//  Created by Mike Sabo on 1/23/16.
//  Copyright © 2016 FlyingDinosaurs. All rights reserved.
//

import Foundation

extension UIView {
  
  func defaultProperties() {
    self.hidden = true
    self.backgroundColor = UIColor.clearColor()
    self.opaque = true
    self.translatesAutoresizingMaskIntoConstraints = false
  }
  
}