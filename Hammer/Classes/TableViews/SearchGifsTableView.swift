//
//  SearchGifsTableView.swift
//  Hammer
//
//  Created by Mike Sabo on 11/8/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation
import ReactiveCocoa

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
    self.registerClass(UITableViewCell.self, forCellReuseIdentifier: "AutocompleteResultCell")
    self.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
    self.separatorColor = UIColor.flatWhiteColor()
    self.separatorInset = UIEdgeInsetsZero
    self.backgroundColor = UIColor.flatMintColor()
    self.bounces = false
  }
  
}
