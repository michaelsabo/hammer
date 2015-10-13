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


class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var viewCollection: UICollectionView!
	@IBOutlet weak var tagSearch: UITextField!
	
	let kCustomRows = 8
	let kImageCell = "ImageCell"
	var gifs = [Gif]()
	var allTags = [Tag]()
	var autocompleteTableView: UITableView = UITableView()
	var tagResults = [Tag]()
	var autocompletionEnabled: Bool = false
	var userIsSearching = false
	var searchedGifs = [Gif]()
	
	var searchTagViewModel: SearchTagViewModel = {
		return SearchTagViewModel(searchTagService: TagAutocompleteService(), gifRetrieveService: GifService())
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addImage")
		
		getInitialImages()
		getAllTags()

	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		setupTableView()
		setupBindings()
	}
	
	func setupBindings() {
		tagSearch.delegate = self
		self.searchTagViewModel.searchText <~ tagSearch.rac_textSignalProducer()
		RAC(autocompleteTableView, "hidden") <~ self.searchTagViewModel.tableWillHide.producer
		self.searchTagViewModel.searchingTagsSignal.producer.start({ s in
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
//		tagSearch.delegate = self
		tagSearch.translatesAutoresizingMaskIntoConstraints = false
		viewCollection.translatesAutoresizingMaskIntoConstraints = false
		autocompleteTableView.hidden = true
		view.addSubview(autocompleteTableView)
		let viewDictionary: [String:AnyObject] = ["searchField": tagSearch, "tableView":autocompleteTableView, "collectionView": viewCollection]
		self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[searchField(40)]-5-[collectionView]", options: [], metrics: nil, views: viewDictionary))
		
	}

	// MARK: Service Calls
	
	func getInitialImages() {
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
			Gif.getGifs( { (arrayOfGifs, isSuccess, error) in
				if (isSuccess) {
					self.gifs = arrayOfGifs!
					self.viewCollection.reloadData()
				}
			})
		}
	}
	
	func getAllTags() {
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) { [unowned self] in
			TagWrapper.getAllTags( { (tags, isSuccess, error) in
					if (isSuccess) {
						if (tags != nil) {
							self.allTags = tags!
							self.searchTagViewModel.allTags = MutableProperty<[Tag]>(self.allTags)
						}
					}
				})
		}
	}
	
	func getGifsForTag(tagSearch: String) {
		searchedGifs = [Gif]()
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
			Gif.getGifsForTagQuery(tagSearch, completionHandler: { (response, isSuccess, error) in
				if (isSuccess) {
					if let gifsResponse = response {
						if (gifsResponse.count > 0) {
							self.userIsSearching = true
							self.searchedGifs = gifsResponse
							self.viewCollection.reloadData()
						}
					}
				}
			})
			
		}
	}
	
	func addImage() {
		// just using this to debug how many images are currently stored in the gifs array
		// at various points of the ui collection view when scrolling
		let returnedArray = self.gifs.filter( {
			if let type = $0 as Gif? {
				return type.thumbnailImage != nil
			}
		})
		print(returnedArray.count)
	}

	
	// MARK: UICollectionView Data Methods
	
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if (gifs.count == 0) {
			return kCustomRows
		} else if (userIsSearching) {
			return searchedGifs.count
		} else {
			return gifs.count
		}
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		var cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCell
		cell.userInteractionEnabled = true
		if (userIsSearching && indexPath.item < searchedGifs.count) {
			cell = displayCellForGifs(searchedGifs, indexPath: indexPath, cell: cell)
			return cell
		} else if (!userIsSearching && indexPath.item < gifs.count) {
			cell = displayCellForGifs(gifs, indexPath: indexPath, cell: cell)
			return cell
		} else {
			cell.imageView.image = UIImage(named: "Placeholder.png")
			cell.userInteractionEnabled = false
		}
		return cell
	}
	
	func displayCellForGifs(gifCollection: [Gif], indexPath: NSIndexPath, cell: ImageCell) -> ImageCell {	
		if (indexPath.item < gifCollection.count) {
			let gif = gifCollection[indexPath.item]
			if let image = gif.thumbnailImage {
				cell.imageView.image = image
			} else {
				dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
					Gif.getThumbnailImageForGif(gif, completionHandler: { [unowned self] (responseGif, isSuccess, error) in
						if (isSuccess && !self.userIsSearching) {
							if let index = self.gifs.indexOf(responseGif!) {
								gifCollection[index].thumbnailImage = responseGif!.thumbnailImage
								cell.imageView.image = gifCollection[index].thumbnailImage
							}
						} else if (isSuccess && self.userIsSearching) {
							if let index = self.searchedGifs.indexOf(responseGif!) {
								self.searchedGifs[index].thumbnailImage = responseGif!.thumbnailImage
								cell.imageView.image = self.searchedGifs[index].thumbnailImage
							}
						} else {
							cell.imageView.image = UIImage(named: "Placeholder.png")
							cell.userInteractionEnabled = false
						}
						})
				}
			}
		}
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		
		let detailController = storyboard?.instantiateViewControllerWithIdentifier("DisplayViewController") as? DisplayViewController
		if let detailController = detailController {
			if (userIsSearching) {
				detailController.gif = searchedGifs[indexPath.item]
			} else {
				detailController.gif = gifs[indexPath.item]
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
		transition.duration = 0.3
		cell.layer.addAnimation(transition, forKey: kCATransitionReveal)
	}
	
	// MARK: UITableView Data Methods
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.searchTagViewModel.foundTags.value.count
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func adjustHeightOfTableView() {
		var tableHeight: Int
		if (self.searchTagViewModel.foundTags.value.count >= 5) {
			tableHeight = 35 * 5
		} else {
			tableHeight = self.searchTagViewModel.foundTags.value.count * 35
		}
		autocompleteTableView.frame = CGRectMake(autocompleteTableView.frame.origin.x, autocompleteTableView.frame.origin.y, CGFloat(autocompleteTableView.frame.size.width), CGFloat(tableHeight));
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cellIdentifier = "AutocompleteResultCell"
		var cell = autocompleteTableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
		
		if (cell == nil) {
			cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
		}
		if (self.searchTagViewModel.foundTags.value.count-1 >= indexPath.row) {
			cell.textLabel?.text = self.searchTagViewModel.foundTags.value[indexPath.row].text
		}
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.tagSearch.text = self.searchTagViewModel.foundTags.value[indexPath.row].text
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
	
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		if (tagSearch.text?.characters.count > 0) {
			getGifsForTag(self.searchTagViewModel.searchText.value)
			self.searchTagViewModel.isSearching.value = false
			autocompleteTableView.hidden = true
			view.endEditing(true)
		}
		return true
	}
	
	func textFieldShouldClear(textField: UITextField) -> Bool {
		tagSearch.text = ""
		autocompleteTableView.hidden = true
		userIsSearching = false
		viewCollection.reloadData()
		return true
	}


	

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
	}
	
	
}
