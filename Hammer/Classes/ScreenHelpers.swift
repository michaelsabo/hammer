//
//  ScreenHelpers.swift
//  Hammer
//
//  Created by Mike Sabo on 11/7/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation

struct Screen {
  
  static var screenWidth:CGFloat {
    get {
      return UIScreen.mainScreen().bounds.width
    }
  }
  static var screenHeight:CGFloat {
    get {
      return UIScreen.mainScreen().bounds.height
    }
  }
}