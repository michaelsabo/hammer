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
  
  @IBOutlet weak var tableViewOutlet: UITableView!
  
  let settingsViewModel : SettingsViewModel = {
    return SettingsViewModel()
  }()
  
  override func viewDidLoad() {
    self.title = "Settings"
    let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "removeViewController")
		navigationController?.navigationItem.leftBarButtonItems = [doneButton]
    self.navigationItem.leftBarButtonItem = doneButton
    loadColorTheme()
    super.viewDidLoad()
    self.settingsViewModel.changeThemeSignal.observeNext({ [weak self] darkTheme in
      self?.loadColorTheme()
    })
  }
  
  func loadColorTheme() {
    self.configureNavigationBar()
    self.tableViewOutlet.backgroundColor = ColorThemes.getBackgroundColor()
    self.tableViewOutlet.reloadData()
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
  
  func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let headerView = view as! UITableViewHeaderFooterView
    headerView.textLabel?.textColor = ColorThemes.tableViewHeaderTextColor()
  }
  
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return settingsViewModel.numberOfSections
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settingsViewModel.numberOfRowsForSection(section)
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = UITableViewCell.init()
    cell = settingsViewModel.cellForSectionAndRow(indexPath, cell: cell)
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if (indexPath.section == 1) {
      let licVC = LicensesViewController()
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
      self.navigationController?.pushViewController(licVC, animated: true)
    }
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
}
