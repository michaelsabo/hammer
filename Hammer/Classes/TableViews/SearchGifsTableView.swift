//
//  SearchGifsTableView.swift
//  Hammer
//
//  Created by Mike Sabo on 11/8/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation


class SearchGifsTableView : UITableView {
  
  override init(frame: CGRect, style: UITableViewStyle) {
    super.init(frame: frame, style: style)
    initialize()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }
  
  func initialize() {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.register(UITableViewCell.self, forCellReuseIdentifier: "AutocompleteResultCell")
    self.separatorStyle = UITableViewCellSeparatorStyle.singleLine
    self.separatorColor = UIColor.flatBlackDark
    self.separatorStyle = .none
    self.backgroundColor = UIColor.clear
    self.bounces = false
  }
  
}

extension UITableViewCell {
  
  func defaultAutocompleteProperties() {
    self.textLabel?.font = App.fontLight()
    self.textLabel?.textColor = ColorThemes.tableViewHeaderTextColor()
    self.backgroundColor = UIColor.clear
    self.selectionStyle = .none
  }
}
