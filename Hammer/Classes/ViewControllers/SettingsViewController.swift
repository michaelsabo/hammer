//
//  SettingsViewController.swift
//  Hammer
//
//  Created by Mike Sabo on 11/1/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit

class SettingsViewController : UIViewController, UINavigationBarDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource   {
		
  let cellIdentifier = "tableCell"
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    
    let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "removeViewController")
    let navigationBar = UINavigationBar(title: "Settings", viewWidth: UIScreen.mainScreen().bounds.width, withRightButtons: nil, andLeftButtons: [doneButton])
    navigationBar.delegate = self;
    self.view.addSubview(navigationBar)
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  func removeViewController() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  //MARK: Table View Methods
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Options"
  }
  
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell.init()
    cell.textLabel?.text = "Licenses"
    cell.tag = 100
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let licVC = LicensesViewController()
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    self.navigationController?.pushViewController(licVC, animated: true)
  }
  
  
}
