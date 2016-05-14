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
private let kDarkEnabled = "darkThemeEnabled"
private let kShowUpdateAlert = "showUpdateAlert"

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
  
  class var darkThemeEnabled : Bool {
    get {
      return NSUserDefaults.standardUserDefaults().boolForKey(kDarkEnabled)
    } set {
      NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: kDarkEnabled)
    }
  }
  
  class var showUpdateAlert : Bool {
    get {
      return NSUserDefaults.standardUserDefaults().boolForKey(kShowUpdateAlert)
    } set {
      NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: kShowUpdateAlert)
    }
  }
  
  class func registerUserDefaults() {
    let dictionary = [kShowUpdateAlert: true, kDarkEnabled: true]
    NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
  }
}