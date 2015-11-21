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
  
  let settingsViewModel : SettingsViewModel = {
    return SettingsViewModel()
  }()
  
  override func viewDidLoad() {
    self.title = "Settings"
    self.configureNavigationBar()
    let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "removeViewController")
		navigationController?.navigationItem.leftBarButtonItems = [doneButton]
    self.navigationItem.leftBarButtonItem = doneButton
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
    return settingsViewModel.titleForSection(section)
  }
  
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return settingsViewModel.numberOfSections
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settingsViewModel.numberOfRowsForSection(section)
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell.init()
    cell.textLabel?.text = settingsViewModel.titleForSectionAndRow(indexPath)
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if (indexPath.section == 0 && indexPath.row == 0) {
      let cavc = ChooseAnimationViewController(nibName: "CustomizationViewController", bundle: NSBundle.mainBundle())
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
      self.navigationController?.pushViewController(cavc, animated: true)
    } else {
      let licVC = LicensesViewController()
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
      self.navigationController?.pushViewController(licVC, animated: true)
    }
  }
  
  
}
