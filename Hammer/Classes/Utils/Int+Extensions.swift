//
//  Data+Extensions.swift
//  Hammer
//
//  Created by Mike Sabo on 1/14/17.
//  Copyright © 2017 FlyingDinosaurs. All rights reserved.
//

import Foundation

extension Int {
  
  var fileSize : String  {
    get {
      let kb = self / 1000
      if kb > 1000 {
        return "\(kb / 1000).\(kb % 100) MB"
      } else {
        return "\(kb) KB"
      }
    }
  }
  
}
