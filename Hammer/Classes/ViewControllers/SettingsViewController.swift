//
//  SettingsViewController.swift
//  Hammer
//
//  Created by Mike Sabo on 11/1/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UINavigationBarDelegate  {
		
  var scrollView: UIScrollView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 64))
    navigationBar.barTintColor = UIColor.flatTealColor()
    navigationBar.tintColor = UIColor.flatWhiteColor()
    let textAttributes = [NSForegroundColorAttributeName:UIColor.flatWhiteColor()]
    navigationBar.titleTextAttributes = textAttributes
    navigationBar.delegate = self;
    let navigationItem = UINavigationItem()
    navigationItem.title = "Acknowledgements"
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "removeViewController")
    navigationBar.items = [navigationItem]
    self.view.addSubview(navigationBar)
    
    scrollView = UIScrollView(frame: CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height-64))
    scrollView.backgroundColor = UIColor.flatWhiteColor()
    
    self.view.addSubview(scrollView)
    let textView = UITextView(frame: CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height))
    if let path = NSBundle.mainBundle().pathForResource("Licenses", ofType: "txt") {
      let licenses = try? NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
      textView.text = licenses
      textView.backgroundColor = UIColor.flatWhiteColor()
      textView.setNeedsDisplay()
      self.view.addSubview(textView)
      scrollView.contentSize = textView.contentSize
    }
    self.view.layoutIfNeeded()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  func removeViewController() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
    return UIBarPosition.TopAttached
  }

  

}
