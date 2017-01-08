//
//  SettingsViewModel.swift
//  Hammer
//
//  Created by Mike Sabo on 11/6/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation
import RxSwift

class SettingsViewModel : NSObject {
  
  let customizeList = ["Dark Theme"]
  let legaleseList = ["Licenses"]
  let sections = ["Customize", "Legalese"]
  let numberOfSections = 2
  
  let darkThemeObserver = Variable(UserDefaults.darkThemeEnabled)

  override init() {
    super.init()
  }
  
  func cellForSectionAndRow(_ indexPath: IndexPath, cell: UITableViewCell) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      cell.textLabel?.text = customizeList[indexPath.row]
      cell.tag = 678
      let darkTheme = UISwitch()
      darkTheme.isOn = UserDefaults.darkThemeEnabled 
      darkTheme.addTarget(self, action: #selector(SettingsViewModel.darkThemeTouched(_:)), for: .valueChanged)
      cell.accessoryView = darkTheme
    case 1:
      cell.textLabel?.text = legaleseList[indexPath.row]
    default:
      break
    }
    cell.backgroundColor = UIColor.flatWhite
    return cell
  }
  
  func titleForSection(_ section: Int) -> String {
    return sections[section]
  }
  
  func numberOfRowsForSection(_ section: Int) -> Int {
    switch section {
    case 0:
      return customizeList.count
    case 1:
      return legaleseList.count
    default:
      return 0
    }
  }
  
  func selectItemAtIndexPath(_ indexPath: IndexPath) -> String {
    switch indexPath.section {
    case 0:
      return customizeList[indexPath.row]
    case 1:
      return legaleseList[indexPath.row]
    default:
      return ""
    }
  }
  
  func darkThemeTouched(_ sender: UISwitch) {
    UserDefaults.darkThemeEnabled = sender.isOn
    darkThemeObserver.value = sender.isOn
  }
  
}
