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
    
    navigationController?.navigationBar.barTintColor = UIColor.flatTealColor()
    navigationController?.navigationBar.tintColor = UIColor.flatWhiteColor()
    let textAttributes = [NSForegroundColorAttributeName:UIColor.flatWhiteColor()]
    navigationController?.navigationBar.titleTextAttributes = textAttributes
  }
}