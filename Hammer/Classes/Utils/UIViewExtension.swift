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
    self.isHidden = true
    self.backgroundColor = UIColor.clear
    self.isOpaque = true
    self.translatesAutoresizingMaskIntoConstraints = false
  }
  
}
