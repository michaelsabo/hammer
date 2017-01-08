//
//  SettingsViewController.swift
//  Hammer
//
//  Created by Mike Sabo on 11/1/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit
import RxSwift

class SettingsViewController : UIViewController, UINavigationBarDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource   {
		
  let cellIdentifier = "tableCell"
  
  @IBOutlet weak var tableViewOutlet: UITableView!
  
  let settingsViewModel : SettingsViewModel = {
    return SettingsViewModel()
  }()
  
  var disposeBag:DisposeBag! = DisposeBag()
  
  override func viewDidLoad() {
    self.title = "Settings"
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SettingsViewController.removeViewController))
		navigationController?.navigationItem.leftBarButtonItems = [doneButton]
    self.navigationItem.leftBarButtonItem = doneButton
    loadColorTheme()
    super.viewDidLoad()
    
    self.settingsViewModel.darkThemeObserver
      .asObservable()
      .subscribe(onNext: { [weak self] val in
        self?.loadColorTheme()
      }).addDisposableTo(disposeBag)
  }
  
  func loadColorTheme() {
    self.configureNavigationBar()
    self.tableViewOutlet.backgroundColor = ColorThemes.getBackgroundColor()
    self.tableViewOutlet.reloadData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  func removeViewController() {
    self.dismiss(animated: true, completion: nil)
  }
  
  
  //MARK: Table View Methods
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return settingsViewModel.titleForSection(section)
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let headerView = view as! UITableViewHeaderFooterView
    headerView.textLabel?.textColor = ColorThemes.tableViewHeaderTextColor()
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return settingsViewModel.numberOfSections
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settingsViewModel.numberOfRowsForSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell.init()
    cell = settingsViewModel.cellForSectionAndRow(indexPath, cell: cell)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if (indexPath.section == 1) {
      let licVC = LicensesViewController()
      tableView.deselectRow(at: indexPath, animated: true)
      self.navigationController?.pushViewController(licVC, animated: true)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  deinit {
    disposeBag = nil
  }
}
