//
//  UserDefaults.swift
//  Hammer
//
//  Created by Mike Sabo on 12/5/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation


private let numberOfTagsAdded = "numberOfTagsAdded"
private let numberOfShares = "numberOfShares"

class UserDefaults {
  
  class var totalTagsAdded : Int {
    get {
      return NSUserDefaults.standardUserDefaults().integerForKey(numberOfTagsAdded)
    }
  }
  
  class func incrementTagsAdded() {
      let newTotal = totalTagsAdded + 1
      NSUserDefaults.standardUserDefaults().setInteger(newTotal, forKey: numberOfTagsAdded)
    
  }
  
  class var totalShares : Int {
    get {
      return NSUserDefaults.standardUserDefaults().integerForKey(numberOfShares)
    }
  }
  
  class func incrementTotalShares() {
    let newTotal = totalShares + 1
    NSUserDefaults.standardUserDefaults().setInteger(newTotal, forKey: numberOfShares)
  }
}