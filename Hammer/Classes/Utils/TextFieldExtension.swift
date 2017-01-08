//
//  TextFieldExtension.swift
//  Hammer
//
//  Created by Mike Sabo on 1/23/16.
//  Copyright © 2016 FlyingDinosaurs. All rights reserved.
//

import Foundation

extension UITextField {
  
  func createSearchTextField(placeholder:String) {
    self.placeholder = placeholder
    self.isHidden = true
    self.textAlignment = .center
    self.backgroundColor = UIColor.flatWhite
    self.layer.cornerRadius = 15.0
    self.autocorrectionType = .no
    self.clearButtonMode = .always
    self.translatesAutoresizingMaskIntoConstraints = false
    self.font = App.fontLight(20.0)
    self.autocapitalizationType = .allCharacters
  }
  
}
