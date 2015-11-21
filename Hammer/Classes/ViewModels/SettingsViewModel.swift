//
//  SettingsViewModel.swift
//  Hammer
//
//  Created by Mike Sabo on 11/6/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation

class SettingsViewModel : NSObject {
  
  let customizeList = ["Loading Animations"]
  let legaleseList = ["Licenses"]
  let numberOfSections = 2
  
  override init() {
    super.init()
  }
  
  func titleForSectionAndRow(indexPath: NSIndexPath) -> String {
    if (indexPath.section == 0) {
      return customizeList[indexPath.row]
    }
    if (indexPath.section == 1) {
      return legaleseList[indexPath.row]
    } else {
      return ""
    }
  }
  
  func titleForSection(section: Int) -> String {
    if (section == 0) {
      return "Customizations"
    }
    if (section == 1) {
      return "Legalese"
    } else {
      return ""
    }
  }
  
  func numberOfRowsForSection(section: Int) -> Int {
    if (section == 0) {
      return customizeList.count
    }
    if (section == 1) {
      return legaleseList.count
    } else {
      return 0
    }
  }
  
  func selecteItemAtIndexPath(indexPath: NSIndexPath) -> String {
    if (indexPath.section == 0) {
      return customizeList[indexPath.row]
    }
    if (indexPath.section == 1) {
      return legaleseList[indexPath.row]
    } else {
      return ""
    }
  }
	
  
}