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
    
//    navigationController?.navigationBar.barTintColor = UIColor.flatTealColor()
//    navigationController?.navigationBar.tintColor = UIColor.flatWhiteColor()
//    let textAttributes:[String:AnyObject] = [NSForegroundColorAttributeName:UIColor.flatWhiteColor()]
//    navigationController?.navigationBar.titleTextAttributes = textAttributes
      navigationController?.navigationBar.barTintColor = ColorThemes.navigationBarBackgroundColor()
                navigationController?.navigationBar.translucent = false
      navigationController?.navigationBar.tintColor = ColorThemes.navigationBarIconColor()
      let textAttributes:[String:AnyObject] = [NSForegroundColorAttributeName:ColorThemes.navigationBarIconColor()]
      navigationController?.navigationBar.titleTextAttributes = textAttributes
  }
  
  func setNavigationBarColors() {
    if (UserDefaults.darkThemeEnabled) {
      navigationController?.navigationBar.barTintColor = UIColor.flatBlackColorDark()
      navigationController?.navigationBar.tintColor = UIColor.flatRedColor()
            navigationController?.navigationBar.translucent = false
      let textAttributes:[String:AnyObject] = [NSForegroundColorAttributeName:UIColor.flatRedColor()]
      navigationController?.navigationBar.titleTextAttributes = textAttributes
    } else {
      navigationController?.navigationBar.barTintColor = UIColor.flatTealColor()
      navigationController?.navigationBar.tintColor = UIColor.flatWhiteColor()
      let textAttributes:[String:AnyObject] = [NSForegroundColorAttributeName:UIColor.flatWhiteColor()]
      navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
  }
}

class ColorThemes {
  
  class func getBackgroundColor() -> UIColor {
    if (UserDefaults.darkThemeEnabled) {
//      return UIColor(red: CGFloat(37/255), green: CGFloat(37/255), blue: CGFloat(37/255), alpha: 1.0)
      return UIColor.flatBlackColorDark()
    } else {
      return UIColor.flatWhiteColorDark()
    }
  }
  
  class func navigationBarIconColor() -> UIColor {
    if (UserDefaults.darkThemeEnabled) {
      return UIColor.flatWhiteColor()
    } else {
      return UIColor.flatWhiteColor()
    }
  }
  
  class func navigationBarBackgroundColor() -> UIColor {
    if (UserDefaults.darkThemeEnabled) {
//      return UIColor.flatBlueColorDark()
      return  UIColor(red: CGFloat(21/255), green: CGFloat(21/255), blue: CGFloat(21/255), alpha: 0.1)
    } else {
      return UIColor.flatTealColor()
    }
  }
  
  class func viewTextColor() -> UIColor {
    if (UserDefaults.darkThemeEnabled) {
      return  UIColor.flatWhiteColor()
    } else {
      return UIColor.flatWhiteColor()
    }
  }
  
  class func getOutlineColor() -> UIColor {
    if (UserDefaults.darkThemeEnabled) {
      return  UIColor.flatWhiteColorDark()
    } else {
      return UIColor.clearColor()
    }
  }
  
  class func animationColor() -> UIColor {
    if (UserDefaults.darkThemeEnabled) {
      return  UIColor.flatWhiteColor()
    } else {
      return UIColor.flatTealColor()
    }
  }
  
  class func tagBackgroundColor() -> UIColor {
    if (UserDefaults.darkThemeEnabled) {
      return UIColor(red: CGFloat(21/255), green: CGFloat(21/255), blue: CGFloat(21/255), alpha: 1.0)
    } else {
      return UIColor.flatTealColor()
    }
  }
  
  class func tableViewHeaderTextColor() -> UIColor {
    if (UserDefaults.darkThemeEnabled) {
      return  UIColor.flatWhiteColor()
    } else {
      return UIColor.flatBlackColor()
    }
  }
}