//
//  NavigationBar.swift
//  Hammer
//
//  Created by Mike Sabo on 11/3/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation

extension UINavigationBar {
  
  convenience init(title: String, viewWidth: CGFloat, withRightButtons rightButtons: [UIBarButtonItem]?, andLeftButtons leftButtons:[UIBarButtonItem]?) {
    self.init(frame:CGRectMake(0, 0, viewWidth, 64))
    self.barTintColor = UIColor.flatTealColor()
    self.tintColor = UIColor.flatWhiteColor()
    let textAttributes = [NSForegroundColorAttributeName:UIColor.flatWhiteColor()]
    self.titleTextAttributes = textAttributes
    let navigationItems = UINavigationItem()
    navigationItems.title = title
    navigationItems.leftBarButtonItems = leftButtons
    navigationItems.rightBarButtonItems = rightButtons
    self.items = [navigationItems]

  }
  
}