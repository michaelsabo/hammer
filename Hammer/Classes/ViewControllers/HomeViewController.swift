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
	
  @IBOutlet weak var viewCollection:UICollectionView!
  var tagSearch:UITextField!
	var autocompleteTableView:UITableView = UITableView()
  var searchView:UIView!
	
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
		
		self.configureNavigationBar()
    
    let settingsIcon = UIBarButtonItem()
    settingsIcon.FAIcon = FAType.FAGear
    settingsIcon.action = "showSettings"
    settingsIcon.target = self
    let searchIcon = UIBarButtonItem()
    searchIcon.FAIcon = FAType.FASearch
    searchIcon.action = "showSearch"
    searchIcon.target = self
    navigationItem.leftBarButtonItem = settingsIcon
    navigationItem.rightBarButtonItem = searchIcon
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
    
    self.viewCollection.registerNib(UINib.init(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
		let frame = CGRectMake(0, 110, Screen.screenWidth-20, 200)
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
    self.viewCollection.backgroundColor = UIColor.flatWhiteColorDark()
    searchView = UIView.init(frame: CGRectMake(0, 67, Screen.screenWidth, 90))
    searchView.hidden = true
    searchView.backgroundColor = UIColor.clearColor()
    searchView.opaque = true
    searchView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(searchView)
    self.view.addConstraint(NSLayoutConstraint(item: searchView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: searchView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: searchView, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0))

    self.view.addConstraint(NSLayoutConstraint(item: searchView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 90))
    self.view.addConstraint(NSLayoutConstraint(item: searchView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: Screen.screenWidth))
    tagSearch = UITextField.init(frame: CGRectMake(0, 0, self.view.frame.size.width-20, 60))
    tagSearch.placeholder = "Whatya looking for?"
    tagSearch.hidden = true
    tagSearch.textAlignment = .Center
    tagSearch.alpha = 1
    tagSearch.backgroundColor = UIColor.flatWhiteColor()
    tagSearch.layer.cornerRadius = 15.0
    tagSearch.autocorrectionType = .No
    viewCollection.translatesAutoresizingMaskIntoConstraints = false
    tagSearch.translatesAutoresizingMaskIntoConstraints = false
    self.searchView.addSubview(tagSearch)

    self.searchView.addConstraint(NSLayoutConstraint(item: tagSearch, attribute: .Left, relatedBy: .Equal, toItem: searchView, attribute: .Left, multiplier: 1, constant: 10))
    self.searchView.addConstraint(NSLayoutConstraint(item: searchView, attribute: .Right, relatedBy: .Equal, toItem: tagSearch, attribute: .Right, multiplier: 1, constant: 10))
    self.searchView.addConstraint(NSLayoutConstraint(item: tagSearch, attribute: .Top, relatedBy: .Equal, toItem: searchView, attribute: .Top, multiplier: 1, constant: 10))
    self.searchView.addConstraint(NSLayoutConstraint(item: tagSearch, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 60))
    self.searchView.addConstraint(NSLayoutConstraint(item: tagSearch, attribute: .CenterY, relatedBy: .Equal, toItem: searchView, attribute: .CenterY, multiplier: 1, constant: 0))
    
    tagSearch.font = App.fontLight(20.0)
    tagSearch.autocapitalizationType = .AllCharacters
		view.addSubview(autocompleteTableView)
    self.view.addConstraint(NSLayoutConstraint(item: autocompleteTableView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 10))
    self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Right, relatedBy: .Equal, toItem: autocompleteTableView, attribute: .Right, multiplier: 1, constant: 10))
    self.view.addConstraint(NSLayoutConstraint(item: autocompleteTableView, attribute: .Top, relatedBy: .Equal, toItem: tagSearch, attribute: .Bottom, multiplier: 1, constant: 0))
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
    let displayViewController = DisplayViewController(nibName: "DisplayViewController", bundle: NSBundle.mainBundle())
    let gif = self.homeViewModel.gifsForDisplay.value[indexPath.item]
    if (gif.thumbnailData != nil) {
      displayViewController.displayGifViewModel = DisplayViewModel(gif: gif)
      navigationController?.pushViewController(displayViewController, animated: true)
    }
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
    if (autocompleteTableView.hidden) {
      view.endEditing(true)
      removeBlurView()
      self.searchView.hidden = true
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
      cell.textLabel?.font = App.fontLight()
			cell.textLabel?.text = self.homeViewModel.foundTags.value[indexPath.row].name.uppercaseString
		}
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.tagSearch.text = self.homeViewModel.foundTags.value[indexPath.row].name
		autocompleteTableView.deselectRowAtIndexPath(indexPath, animated: true)
		textFieldShouldReturn(self.tagSearch)
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 35.0
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		view.endEditing(true)
    self.homeViewModel.endSeaching()
    removeBlurView()
    self.searchView.hidden = true
    self.tagSearch.hidden = true
    self.viewCollection.superview?.bringSubviewToFront(viewCollection)
	}
	
	// MARK: UI Text Field Delegates
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
    autocompleteTableView.hidden = true
    tagSearch.hidden = true
    searchView.hidden = true
    removeBlurView()
    self.homeViewModel.endSeaching()
    self.viewCollection.superview?.bringSubviewToFront(viewCollection)
    self.homeViewModel.getGifsForTagSearch()
    view.endEditing(true)
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
  
  func removeBlurView() {
    for subview in self.view.subviews {
      if (subview.tag == 8888) {
        subview.removeFromSuperview()
      }
    }
  }
  
  
  func showSearch() {
    var shouldHide:Bool = true
    if (searchView.hidden) {
      shouldHide = false
      addBlurEffect()
      searchView.superview?.bringSubviewToFront(searchView)
      autocompleteTableView.superview?.bringSubviewToFront(autocompleteTableView)
    } else {
      removeBlurView()
    }
    tagSearch.hidden = shouldHide
    searchView.hidden = shouldHide
  }
  
  func addBlurEffect() {
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = self.view.bounds
    blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    blurEffectView.tag = 8888
    view.addSubview(blurEffectView)
  }
  
  // MARK: shake delegates
  
  override func canBecomeFirstResponder() -> Bool {
    return true
  }
  
  override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
    if motion == .MotionShake {
      self.homeViewModel.mixupGifArray()
    }
  }

	
}
