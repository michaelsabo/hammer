//
//  TextFieldExtension.swift
//  Hammer
//
//  Created by Mike Sabo on 1/23/16.
//  Copyright © 2016 FlyingDinosaurs. All rights reserved.
//

import Foundation

extension UITextField {
  
  func createSearchTextField(placeholder placeholder:String) {
    self.placeholder = placeholder
    self.hidden = true
    self.textAlignment = .Center
    self.backgroundColor = UIColor.flatWhiteColor()
    self.layer.cornerRadius = 15.0
    self.autocorrectionType = .No
    self.clearButtonMode = .Always
    self.translatesAutoresizingMaskIntoConstraints = false
    self.font = App.fontLight(20.0)
    self.autocapitalizationType = .AllCharacters
  }
  
}