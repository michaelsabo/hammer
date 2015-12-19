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
  let numberOfSections = 1
  
  override init() {
    super.init()
  }
  
  func titleForSectionAndRow(indexPath: NSIndexPath) -> String {
    return legaleseList[indexPath.row]
  }
  
  func titleForSection(section: Int) -> String {
      return "Legalese"
  }
  
  func numberOfRowsForSection(section: Int) -> Int {
    return legaleseList.count
  }
  
  func selecteItemAtIndexPath(indexPath: NSIndexPath) -> String {
    return legaleseList[indexPath.row]
  }
	
  
}