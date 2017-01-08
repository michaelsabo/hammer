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
      return Foundation.UserDefaults.standard.integer(forKey: numberOfTagsAdded)
    }
  }
  
  class func incrementTagsAdded() {
      let newTotal = totalTagsAdded + 1
      Foundation.UserDefaults.standard.set(newTotal, forKey: numberOfTagsAdded)
    
  }
  
  class var totalShares : Int {
    get {
      return Foundation.UserDefaults.standard.integer(forKey: numberOfShares)
    }
  }
  
  class func incrementTotalShares() {
    let newTotal = totalShares + 1
    Foundation.UserDefaults.standard.set(newTotal, forKey: numberOfShares)
  }
  
  class var darkThemeEnabled : Bool {
    get {
      return Foundation.UserDefaults.standard.bool(forKey: kDarkEnabled)
    } set {
      Foundation.UserDefaults.standard.set(newValue, forKey: kDarkEnabled)
    }
  }
  
  class var showUpdateAlert : Bool {
    get {
      return Foundation.UserDefaults.standard.bool(forKey: kShowUpdateAlert)
    } set {
      Foundation.UserDefaults.standard.set(newValue, forKey: kShowUpdateAlert)
    }
  }
  
  class func registerUserDefaults() {
    let dictionary = [kShowUpdateAlert: true, kDarkEnabled: true]
    Foundation.UserDefaults.standard.register(defaults: dictionary)
  }
}
