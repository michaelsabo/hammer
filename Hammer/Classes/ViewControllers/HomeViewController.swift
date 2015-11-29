//
//  HomeViewController.swift
//  Hammer
//
//  Created by Mike Sabo on 10/4/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit
import SwiftyJSON
import ReactiveCocoa
import ChameleonFramework
import NVActivityIndicatorView
import Font_Awesome_Swift

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout {
	
	@IBOutlet weak var viewCollection: UICollectionView!
	@IBOutlet weak var tagSearch: UITextField!
	var autocompleteTableView: UITableView = UITableView()
	
	let kCustomRows = 8
	let kImageCell = "ImageCell"
	var refreshControl = UIRefreshControl()
  
	let homeViewModel: HomeViewModel = {
		return HomeViewModel(searchTagService: TagService(), gifRetrieveService: GifService())
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = self.homeViewModel.title
		self.view.backgroundColor = UIColor.flatWhiteColorDark()
		self.viewCollection.backgroundColor = UIColor.flatWhiteColorDark()
		self.configureNavigationBar()
    
    let codeIcon = UIBarButtonItem()
    codeIcon.FAIcon = FAType.FAGear
    codeIcon.action = "showSettings"
    codeIcon.target = self
    navigationItem.leftBarButtonItem = codeIcon
		setupViews()
		setupBindings()
	}
	
	func setupBindings() {
		tagSearch.delegate = self
		self.homeViewModel.searchText <~ tagSearch.rac_textSignalProducer()
    RAC(self.autocompleteTableView, "hidden") <~ SignalProducer(signal: self.homeViewModel.isSearchingSignal.map({!$0}))

		self.homeViewModel.gifsForDisplay.producer.startWithSignal( { signal, disposable in
			signal.observe({ _ in
				self.viewCollection.reloadData()
        self.refreshControl.endRefreshing()
			})
		})
    
		self.homeViewModel.searchingTagsSignal.producer.start({ s in
			self.adjustHeightOfTableView()
			self.autocompleteTableView.reloadData()
		})
	}
	
	func setupViews() {
		let frame = CGRectMake(0, 110, view.frame.width, 200)
		autocompleteTableView = SearchGifsTableView(frame: frame, style: UITableViewStyle.Plain)
		autocompleteTableView.delegate = self
		autocompleteTableView.dataSource = self
		if (Screen.screenWidth > 400) {
			self.viewCollection.collectionViewLayout = LargeCollectionViewLayout.init()
		} else if (Screen.screenWidth > 350) {
			self.viewCollection.collectionViewLayout = MediumCollectionViewLayout.init()
		} else {
			self.viewCollection.collectionViewLayout = SmallCollectionViewLayout.init()
		}
		
		tagSearch.translatesAutoresizingMaskIntoConstraints = false
    tagSearch.font = App.font(20.0)
		viewCollection.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(autocompleteTableView)
    refreshControl.addTarget(self, action: "refreshImages", forControlEvents: UIControlEvents.ValueChanged)
    viewCollection.addSubview(refreshControl)
	}
  
  func refreshImages() {
    self.homeViewModel.getGifs()
  }
	
	// MARK: UICollectionView Data Methods
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
			return self.homeViewModel.gifsForDisplay.value.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCell
		return self.homeViewModel.displayCellForGifs(indexPath: indexPath, cell: cell)
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let displayViewController = storyboard?.instantiateViewControllerWithIdentifier("DisplayViewController") as! DisplayViewController
    let gif = self.homeViewModel.gifsForDisplay.value[indexPath.item]
    if (gif.thumbnailData != nil) {
      displayViewController.displayGifViewModel = DisplayViewModel(gifService: GifService(), tagService: TagService(), gif: gif)
      navigationController?.pushViewController(displayViewController, animated: true)
    }
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
    if (autocompleteTableView.hidden) {
      view.endEditing(true)
    }
	}
  
  func scrollViewDidScrollToTop(scrollView: UIScrollView) {
    viewCollection.reloadItemsAtIndexPaths(viewCollection.indexPathsForVisibleItems())
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    viewCollection.reloadItemsAtIndexPaths(viewCollection.indexPathsForVisibleItems())
  }
	
	// MARK: UITableView Data Methods
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.homeViewModel.foundTags.value.count
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func adjustHeightOfTableView() {
		autocompleteTableView.frame = CGRectMake(autocompleteTableView.frame.origin.x, autocompleteTableView.frame.origin.y, CGFloat(autocompleteTableView.frame.size.width), CGFloat(self.homeViewModel.tagTableViewCellHeight()));
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cellIdentifier = "AutocompleteResultCell"
		var cell = autocompleteTableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
		cell.textLabel?.textColor = UIColor.flatWhiteColor()
		cell.backgroundColor = UIColor.flatTealColor()
		if (cell == nil) {
			cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
		}
		if (self.homeViewModel.foundTags.value.count-1 >= indexPath.row) {
      cell.textLabel?.font = App.font()
			cell.textLabel?.text = self.homeViewModel.foundTags.value[indexPath.row].name
		}
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.tagSearch.text = self.homeViewModel.foundTags.value[indexPath.row].text
		autocompleteTableView.deselectRowAtIndexPath(indexPath, animated: true)
		textFieldShouldReturn(self.tagSearch)
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 35.0
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		view.endEditing(true)
    self.homeViewModel.endSeaching()
	}
	
	// MARK: UI Text Field Delegates
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.homeViewModel.getGifsForTagSearch()
    view.endEditing(true)
    autocompleteTableView.hidden = true
		return true
	}
	
	func textFieldShouldClear(textField: UITextField) -> Bool {
		self.homeViewModel.endSeaching()
		return true
	}
  
  func showSettings() {
    let settingsController = SettingsViewController(nibName: "Settings", bundle: NSBundle.mainBundle())
    let navController = UINavigationController.init(rootViewController: settingsController)
    self.presentViewController(navController, animated: true, completion: nil)
  }

	
}
