//
//  HomeViewController.swift
//  Hammer
//
//  Created by Mike Sabo on 10/4/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit
import SwiftyJSON


class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate {
	
	@IBOutlet weak var viewCollection: UICollectionView!
	@IBOutlet weak var tagSearch: UITextField!
	
	let kCustomRows = 8
	let kImageCell = "ImageCell"
	var gifs = [Gif]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addImage")
		getInitialImages()
		
	}
	
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
	
	
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if (gifs.count == 0) {
			return kCustomRows
		}
		return gifs.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCell
		if (indexPath.row < gifs.count) {
			let gif = gifs[indexPath.item]
			if let image = gif.thumbnailImage {
				cell.imageView.image = image
			} else {
				dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
					Gif.getThumbnailImageForGif(gif, completionHandler: { [unowned self] (responseGif, isSuccess, error) in
						if (isSuccess) {
							if let index = self.gifs.indexOf(responseGif!) {
								self.gifs[index].thumbnailImage = responseGif!.thumbnailImage
								cell.imageView.image = responseGif!.thumbnailImage
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
			detailController.gif = gifs[indexPath.item]
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
	
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
	}
	
	
}
