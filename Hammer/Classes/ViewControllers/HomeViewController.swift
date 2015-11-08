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
    codeIcon.action = "showLicenses"
    codeIcon.target = self
    navigationItem.leftBarButtonItem = codeIcon
		setupViews()
		setupBindings()
	}
	
	func setupBindings() {
		tagSearch.delegate = self
		self.homeViewModel.searchText <~ tagSearch.rac_textSignalProducer()

		self.homeViewModel.gifsForDisplay.producer.startWithSignal( { signal, disposable in
			signal.observe({ _ in
				self.viewCollection.reloadData()
			})
		})
    
    self.homeViewModel.isSearchingSignal
      .observeNext({ [unowned self] (searching:Bool) in
        self.autocompleteTableView.hidden = !searching
        if searching {
          self.adjustHeightOfTableView()
          self.autocompleteTableView.reloadData()
        }
    })
		
    self.homeViewModel.stopSearching()

	}
	
	func setupViews() {
		let frame = CGRectMake(0, 110, view.frame.width, 200)
		autocompleteTableView = UITableView.init(frame: frame, style: UITableViewStyle.Plain)
		autocompleteTableView.translatesAutoresizingMaskIntoConstraints = false
		autocompleteTableView.delegate = self
		autocompleteTableView.dataSource = self
		if (Screen.screenWidth > 400) {
			self.viewCollection.collectionViewLayout = LargeCollectionViewLayout.init()
		} else if (Screen.screenWidth > 350) {
			self.viewCollection.collectionViewLayout = MediumCollectionViewLayout.init()
		} else {
			self.viewCollection.collectionViewLayout = SmallCollectionViewLayout.init()
		}
		
		autocompleteTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "AutocompleteResultCell")
		tagSearch.translatesAutoresizingMaskIntoConstraints = false
		viewCollection.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(autocompleteTableView)
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
    if (gif.thumbnailImage != nil) {
      displayViewController.displayGifViewModel = DisplayViewModel(gifService: GifService(), tagService: TagService(), gif: gif)
      navigationController?.pushViewController(displayViewController, animated: true)
    }
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		view.endEditing(true)
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
		var tableHeight: Int
		if (self.homeViewModel.foundTags.value.count >= 5) {
			tableHeight = 35 * 5
		} else {
			tableHeight = self.homeViewModel.foundTags.value.count * 35
		}
		autocompleteTableView.frame = CGRectMake(autocompleteTableView.frame.origin.x, autocompleteTableView.frame.origin.y, CGFloat(autocompleteTableView.frame.size.width), CGFloat(tableHeight));
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cellIdentifier = "AutocompleteResultCell"
		var cell = autocompleteTableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
		cell.textLabel?.textColor = UIColor.flatWhiteColor()
		cell.backgroundColor = UIColor.flatMintColor()
		if (cell == nil) {
			cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
		}
		if (self.homeViewModel.foundTags.value.count-1 >= indexPath.row) {
      cell.textLabel?.font = App.font()
			cell.textLabel?.text = self.homeViewModel.foundTags.value[indexPath.row].text
		}
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.tagSearch.text = self.homeViewModel.foundTags.value[indexPath.row].text
		self.homeViewModel.searchText.value = self.homeViewModel.foundTags.value[indexPath.row].text
		autocompleteTableView.deselectRowAtIndexPath(indexPath, animated: true)
		textFieldShouldReturn(self.tagSearch)
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 35.0
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		view.endEditing(true)
    self.homeViewModel.stopSearching()
	}
	
	// MARK: UI Text Field Delegates
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		if (tagSearch.text?.characters.count > 0) {
			self.homeViewModel.isSearching.value = true
			self.homeViewModel.getGifsForTagSearch()
			view.endEditing(true)
			autocompleteTableView.hidden = true
		}
		return true
	}
	
	func textFieldShouldClear(textField: UITextField) -> Bool {
		tagSearch.text = ""
		self.homeViewModel.stopSearching()
		viewCollection.reloadData()
		return true
	}
  
  func showLicenses() {
    let settingsController = SettingsViewController(nibName: "Settings", bundle: NSBundle.mainBundle())
		
  let navController = UINavigationController.init(rootViewController: settingsController)
//    self.navigationController?.pushViewController(settingsController, animated: true)
//   self.navigationController?.pushViewController(settingsController, animated: true)
      self.presentViewController(navController, animated: true, completion: nil)
  
    
  	
  }

	
}
