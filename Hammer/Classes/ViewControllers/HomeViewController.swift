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
    let settingsIcon = UIBarButtonItem().setup(target: self, icon: .FAGear, action: "showSettings")
    let searchIcon = UIBarButtonItem().setup(target: self, icon: .FASearch, action: "updateSearchViews")
    navigationItem.leftBarButtonItem = settingsIcon
    navigationItem.rightBarButtonItem = searchIcon
		setupViews()
		setupBindings()
	}
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.view.backgroundColor = ColorThemes.getBackgroundColor()
    self.configureNavigationBar()
    self.viewCollection.backgroundColor = ColorThemes.getBackgroundColor()
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
		let tableViewframe = CGRectMake(0, 110, Screen.screenWidth-20, 300)
		autocompleteTableView = SearchGifsTableView(frame: tableViewframe, style: UITableViewStyle.Plain)
		autocompleteTableView.delegate = self
		autocompleteTableView.dataSource = self
    view.addSubview(autocompleteTableView)
    self.viewCollection.setCollectionViewLayout()
    searchView = UIView.init(frame: CGRectMake(0, 67, Screen.screenWidth, 90))
    searchView.defaultProperties()
    self.view.addSubview(searchView)
    tagSearch = UITextField.init(frame: CGRectMake(0, 0, self.view.frame.size.width-20, 60))
    tagSearch.createSearchTextField(placeholder: "Whatya looking for?")
    self.searchView.addSubview(tagSearch)
    addAutoLayoutConstraints()
    refreshControl.addTarget(self, action: "refreshImages", forControlEvents: UIControlEvents.ValueChanged)
    viewCollection.addSubview(refreshControl)
	}
  
  func addAutoLayoutConstraints() {
    self.view.addConstraint(NSLayoutConstraint(item: searchView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: searchView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: searchView, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0))
    
    self.view.addConstraint(NSLayoutConstraint(item: searchView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 90))
    self.view.addConstraint(NSLayoutConstraint(item: searchView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: Screen.screenWidth))
    
    self.searchView.addConstraint(NSLayoutConstraint(item: tagSearch, attribute: .Left, relatedBy: .Equal, toItem: searchView, attribute: .Left, multiplier: 1, constant: 10))
    self.searchView.addConstraint(NSLayoutConstraint(item: searchView, attribute: .Right, relatedBy: .Equal, toItem: tagSearch, attribute: .Right, multiplier: 1, constant: 10))
    self.searchView.addConstraint(NSLayoutConstraint(item: tagSearch, attribute: .Top, relatedBy: .Equal, toItem: searchView, attribute: .Top, multiplier: 1, constant: 10))
    self.searchView.addConstraint(NSLayoutConstraint(item: tagSearch, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 60))
    
    self.view.addConstraint(NSLayoutConstraint(item: autocompleteTableView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 10))
    self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Right, relatedBy: .Equal, toItem: autocompleteTableView, attribute: .Right, multiplier: 1, constant: 10))
    self.view.addConstraint(NSLayoutConstraint(item: autocompleteTableView, attribute: .Top, relatedBy: .Equal, toItem: tagSearch, attribute: .Bottom, multiplier: 1, constant: 0))
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
		return self.homeViewModel.displayThumbnailForGif(indexPath: indexPath, cell: cell)
	}
  
  func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    let cell = cell as! ImageCell
    guard cell.hasLoaded else {
      return
    }
    if (self.homeViewModel.gifsForDisplay.value[indexPath.item].showAnimation) {
      cell.imageView.transform = CGAffineTransformMakeScale(0.3, 0.3)

      UIView.animateKeyframesWithDuration(0.5, delay: 0, options: [], animations: { [weak cell] in
        UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.1, animations: { [weak cell] in
          cell?.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        })
        UIView.addKeyframeWithRelativeStartTime(0.1, relativeDuration: 0.2, animations: { [weak cell] in
          cell?.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7)
        })
        UIView.addKeyframeWithRelativeStartTime(0.3, relativeDuration: 0.2, animations: { [weak cell] in
          cell?.imageView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
      }, completion: { [weak self] (finished: Bool) in
        self?.homeViewModel.gifsForDisplay.value[indexPath.item].showAnimation = false
      })
    }
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
    if (self.homeViewModel.foundTags.value.count < 1 && !searchView.hidden) {
      updateSearchViews()
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
		if (cell == nil) {
			cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
		}
		if (self.homeViewModel.foundTags.value.count-1 >= indexPath.row) {
			cell.textLabel?.text = self.homeViewModel.foundTags.value[indexPath.row].name.uppercaseString
		}
    cell.defaultAutocompleteProperties()
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.tagSearch.text = self.homeViewModel.foundTags.value[indexPath.row].name
    self.homeViewModel.searchText.value = self.homeViewModel.foundTags.value[indexPath.row].name
		autocompleteTableView.deselectRowAtIndexPath(indexPath, animated: true)
		textFieldShouldReturn(self.tagSearch)
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return CGFloat(self.homeViewModel.cellHeight)
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    updateSearchViews()
    self.viewCollection.superview?.bringSubviewToFront(viewCollection)
	}
	
	// MARK: UI Text Field Delegates
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
    updateSearchViews()
    self.viewCollection.superview?.bringSubviewToFront(viewCollection)
    self.homeViewModel.getGifsForTagSearch()
		return true
	}
	
	func textFieldShouldClear(textField: UITextField) -> Bool {
    self.homeViewModel.searchText.value = ""
		return true
	}
  
  func showSettings() {
    let settingsController = SettingsViewController(nibName: "Settings", bundle: NSBundle.mainBundle())
    let navController = UINavigationController.init(rootViewController: settingsController)
    self.presentViewController(navController, animated: true, completion: nil)
  }
  
  func updateSearchViews() {
    var shouldHide:Bool = true
    if (searchView.hidden) {
      shouldHide = false
      addBlurEffect()
      searchView.superview?.bringSubviewToFront(searchView)
      autocompleteTableView.superview?.bringSubviewToFront(autocompleteTableView)
      tagSearch.becomeFirstResponder()
    } else {
      removeBlurView()
      view.endEditing(true)
      self.homeViewModel.endSeaching()
    }
    tagSearch.hidden = shouldHide
    searchView.hidden = shouldHide
  }
  
  func addBlurEffect() {
    let blurStyle = UserDefaults.darkThemeEnabled ? UIBlurEffectStyle.Dark : UIBlurEffectStyle.Light
    let blurEffect = UIBlurEffect(style: blurStyle)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = self.view.bounds
    blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    blurEffectView.tag = 8888
    view.addSubview(blurEffectView)
  }
  
  func removeBlurView() {
    for subview in self.view.subviews {
      if (subview.tag == 8888) {
        subview.removeFromSuperview()
      }
    }
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
