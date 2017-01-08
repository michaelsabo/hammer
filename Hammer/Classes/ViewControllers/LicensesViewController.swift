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
    self.configureNavigationBar()
    scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
    self.view.addSubview(scrollView)
    scrollView.backgroundColor = UIColor.flatWhiteColor()
    self.view.addConstraint(NSLayoutConstraint.init(item: scrollView, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))

    let textView = UITextView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
    if let path = Bundle.main.path(forResource: "Licenses", ofType: "txt") {
      let licenses = try? NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String
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
