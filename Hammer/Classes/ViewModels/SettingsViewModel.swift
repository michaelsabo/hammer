//
//  SettingsViewModel.swift
//  Hammer
//
//  Created by Mike Sabo on 11/6/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

class SettingsViewModel : NSObject {
  
  let customizeList = ["Dark Theme"]
  let legaleseList = ["Licenses"]
  let sections = ["Customize", "Legalese"]
  let numberOfSections = 2
  
  let changeThemeSignal: Signal<Bool, NoError>
  let changeThemeObserver: Observer<Bool, NoError>

  override init() {
    let (changeThemeSignal, changeThemeObserver) = Signal<Bool, NoError>.pipe()
    self.changeThemeSignal = changeThemeSignal
    self.changeThemeObserver = changeThemeObserver
    super.init()
  }
  
  func cellForSectionAndRow(indexPath: NSIndexPath, cell: UITableViewCell) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      cell.textLabel?.text = customizeList[indexPath.row]
      cell.tag = 678
      let darkTheme = UISwitch()
      darkTheme.on = UserDefaults.darkThemeEnabled ?? false
      darkTheme.addTarget(self, action: "darkThemeTouched:", forControlEvents: .ValueChanged)
      cell.accessoryView = darkTheme
    case 1:
      cell.textLabel?.text = legaleseList[indexPath.row]
    default:
      break
    }
    cell.backgroundColor = UIColor.flatWhiteColor()
    return cell
  }
  
  func titleForSection(section: Int) -> String {
    return sections[section]
  }
  
  func numberOfRowsForSection(section: Int) -> Int {
    switch section {
    case 0:
      return customizeList.count
    case 1:
      return legaleseList.count
    default:
      return 0
    }
  }
  
  func selectItemAtIndexPath(indexPath: NSIndexPath) -> String {
    switch indexPath.section {
    case 0:
      return customizeList[indexPath.row]
    case 1:
      return legaleseList[indexPath.row]
    default:
      return ""
    }
  }
  
  func darkThemeTouched(sender: UISwitch) {
    UserDefaults.darkThemeEnabled = sender.on
    self.changeThemeObserver.sendNext(sender.on)
  }
  
}