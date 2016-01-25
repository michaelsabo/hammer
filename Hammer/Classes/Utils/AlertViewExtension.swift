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
    self.backgroundColor = ColorThemes.getBackgroundColor()
    self.titleColor = ColorThemes.subviewsColor()
    self.detailColor = ColorThemes.subviewsColor()
    self.splitColor = ColorThemes.subviewsColor()
    self.itemNormalColor = ColorThemes.subviewsColor()
    self.itemHighlightColor = ColorThemes.subviewsColor()
    self.textFieldColor = ColorThemes.subviewsColor()
  }
}