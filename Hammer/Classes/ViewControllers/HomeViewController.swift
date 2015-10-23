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

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var viewCollection: UICollectionView!
	@IBOutlet weak var tagSearch: UITextField!
	var autocompleteTableView: UITableView = UITableView()
	
	let kCustomRows = 8
	let kImageCell = "ImageCell"
	
	var homeViewModel: HomeViewModel = {
		return HomeViewModel(searchTagService: TagAutocompleteService(), gifRetrieveService: GifService())
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "HOWBOWYOUDOEE"
		self.view.backgroundColor = UIColor.flatWhiteColorDark()
		self.viewCollection.backgroundColor = UIColor.flatWhiteColorDark()
//		self.navigationController?.navigationBar.backgroundColor =
		self.navigationController?.navigationBar.barTintColor = UIColor.flatTealColor()
		setupTableView()
		setupBindings()
	}
	
	func setupBindings() {
		tagSearch.delegate = self
		self.homeViewModel.searchText <~ tagSearch.rac_textSignalProducer()
		RAC(autocompleteTableView, "hidden") <~ self.homeViewModel.tableWillHide.producer
		self.homeViewModel.collectionUpdated.producer.start({ s in
			self.viewCollection.reloadData()
		})
		self.homeViewModel.searchingTagsSignal.producer.start({ s in
			self.adjustHeightOfTableView()
			self.autocompleteTableView.reloadData()
		})
	}
	
	func setupTableView() {
		let frame = CGRectMake(0, 120, view.frame.width, 200)
		autocompleteTableView = UITableView.init(frame: frame, style: UITableViewStyle.Plain)
		autocompleteTableView.translatesAutoresizingMaskIntoConstraints = false
		autocompleteTableView.delegate = self
		autocompleteTableView.dataSource = self
		autocompleteTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "AutocompleteResultCell")
		tagSearch.translatesAutoresizingMaskIntoConstraints = false
		viewCollection.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(autocompleteTableView)
	}
	
	// MARK: UICollectionView Data Methods
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if (self.homeViewModel.gifsForDisplay.value.count == 0) {
			return kCustomRows
		} else if (self.homeViewModel.isSearching.value) {
			return self.homeViewModel.gifsForDisplay.value.count
		} else {
			return self.homeViewModel.gifsForDisplay.value.count
		}
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		var cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCell
		cell.userInteractionEnabled = true
		if (self.homeViewModel.isSearching.value && indexPath.item < self.homeViewModel.gifsForDisplay.value.count) {
			cell = self.homeViewModel.displayCellForGifs(indexPath: indexPath, cell: cell)
			return cell
		} else if (!self.homeViewModel.isSearching.value && indexPath.item < self.homeViewModel.gifsForDisplay.value.count) {
			cell = self.homeViewModel.displayCellForGifs(indexPath: indexPath, cell: cell)
			return cell
		} else {
			cell.imageView.image = UIImage(named: "Placeholder.png")
			cell.userInteractionEnabled = false
		}
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		
		let detailController = storyboard?.instantiateViewControllerWithIdentifier("DisplayViewController") as? DisplayViewController
		if let detailController = detailController {
			if (self.homeViewModel.isSearching.value) {
				detailController.gif = self.homeViewModel.gifsForDisplay.value[indexPath.item]
			} else {
				detailController.gif = self.homeViewModel.gifsForDisplay.value[indexPath.item]
			}
			navigationController?.pushViewController(detailController, animated: true)
		}
	}
	
	func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		var transition:CATransition
		transition = CATransition()
		transition.startProgress = 0.7
		transition.endProgress = 1.0
		transition.type = kCATransitionMoveIn
		transition.subtype = kCATransitionFromLeft
		transition.duration = 0.15
		cell.layer.addAnimation(transition, forKey: kCATransitionReveal)
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
		
		if (cell == nil) {
			cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
		}
		if (self.homeViewModel.foundTags.value.count-1 >= indexPath.row) {
			cell.textLabel?.text = self.homeViewModel.foundTags.value[indexPath.row].text
		}
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.tagSearch.text = self.homeViewModel.foundTags.value[indexPath.row].text
		autocompleteTableView .deselectRowAtIndexPath(indexPath, animated: true)
		textFieldShouldReturn(self.tagSearch)
	}
	
	func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 35.0
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		view.endEditing(true)
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
		autocompleteTableView.hidden = true
		self.homeViewModel.isSearching.value = false
		viewCollection.reloadData()
		return true
	}


	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
	}
	
	
}
