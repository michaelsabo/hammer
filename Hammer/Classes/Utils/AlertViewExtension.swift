//
//  AlertViewExtension.swift
//  Hammer
//
//  Created by Mike Sabo on 1/23/16.
//  Copyright © 2016 FlyingDinosaurs. All rights reserved.
//

import Foundation
import MMPopupView

extension MMAlertViewConfig {
  
  func defaultConfig() {
    self.backgroundColor = UIColor.flatWhiteColor()
    self.titleColor = UIColor.flatTealColor()
    self.detailColor = UIColor.flatTealColor()
    self.splitColor = UIColor.flatBlueColor()
    self.itemNormalColor = UIColor.flatTealColor()
    self.itemHighlightColor = UIColor.flatTealColor()
  }
}