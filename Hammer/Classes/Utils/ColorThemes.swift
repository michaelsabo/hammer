//
//  NavigationBar.swift
//  Hammer
//
//  Created by Mike Sabo on 11/3/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation

extension UIViewController
{
  func configureNavigationBar (){
    navigationController?.navigationBar.barTintColor = ColorThemes.navigationBarBackgroundColor()
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.tintColor = ColorThemes.navigationBarIconColor()
    let textAttributes:[String:AnyObject] = [NSForegroundColorAttributeName:ColorThemes.navigationBarIconColor()]
    navigationController?.navigationBar.titleTextAttributes = textAttributes
  }
}

class ColorThemes {
  
  class func getBackgroundColor() -> UIColor {
    if (UserDefaults.darkThemeEnabled) {
      return UIColor.flatBlack
    } else {
      return UIColor.flatWhiteDark
    }
  }
  
  class func navigationBarIconColor() -> UIColor {
    if (UserDefaults.darkThemeEnabled) {
      return UIColor.flatWhite
    } else {
      return UIColor.flatWhite
    }
  }
  
  class func navigationBarBackgroundColor() -> UIColor {
    if (UserDefaults.darkThemeEnabled) {
      return  UIColor(red: CGFloat(37/255), green: CGFloat(37/255), blue: CGFloat(37/255), alpha: 1.0)
    } else {
      return UIColor.flatTeal
    }
  }
  
  class func viewTextColor() -> UIColor {
    if (UserDefaults.darkThemeEnabled) {
      return  UIColor.flatWhite
    } else {
      return UIColor.flatWhite
    }
  }
  
  class func getOutlineColor() -> UIColor {
    if (UserDefaults.darkThemeEnabled) {
      return  UIColor.flatWhiteDark
    } else {
      return UIColor.flatTeal
    }
  }
  
  class func subviewsColor() -> UIColor {
    if (UserDefaults.darkThemeEnabled) {
      return  UIColor.flatWhite
    } else {
      return UIColor.flatTeal
    }
  }
  
  class func tagBackgroundColor() -> UIColor {
    if (UserDefaults.darkThemeEnabled) {
      return UIColor(red: CGFloat(21/255), green: CGFloat(21/255), blue: CGFloat(21/255), alpha: 1.0)
    } else {
      return UIColor.flatTeal
    }
  }
  
  class func tableViewHeaderTextColor() -> UIColor {
    if (UserDefaults.darkThemeEnabled) {
      return  UIColor.flatWhite
    } else {
      return UIColor.flatBlack
    }
  }
}
