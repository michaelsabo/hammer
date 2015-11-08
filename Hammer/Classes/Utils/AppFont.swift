//
//  AppFont.swift
//  Hammer
//
//  Created by Mike Sabo on 11/1/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation

struct App {
  static func font() -> UIFont {
  	return UIFont(name: "HelveticaNeue", size: 16.0)!
  }
  
  static func font(size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue", size: size)!
  }
  
  static func fontBold() -> UIFont {
    return UIFont(name: "HelveticaNeue-Bold", size: 16.0)!
  }
  
  static func fontBold(size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue-Bold", size: size)!
  }
}