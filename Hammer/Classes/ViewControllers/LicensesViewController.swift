//
//  LicensesViewController.swift
//  Hammer
//
//  Created by Mike Sabo on 11/3/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit

class LicensesViewController : UIViewController, UINavigationBarDelegate {
  var scrollView: UIScrollView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let navigationBar = UINavigationBar(title: "Licenses", viewWidth: UIScreen.mainScreen().bounds.width, withRightButtons: nil, andLeftButtons: nil)
    navigationBar.delegate = self;
    self.view.addSubview(navigationBar)
    
    scrollView = UIScrollView(frame: CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height))
    scrollView.backgroundColor = UIColor.flatWhiteColor()
    
    self.view.addSubview(scrollView)
    let textView = UITextView(frame: CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height))
    if let path = NSBundle.mainBundle().pathForResource("Licenses", ofType: "txt") {
      let licenses = try? NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
      textView.text = licenses
      textView.backgroundColor = UIColor.flatWhiteColor()
      self.view.addSubview(textView)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}
