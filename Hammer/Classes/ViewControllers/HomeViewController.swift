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
	
	var gifs = [Gif]()

	var wrapperGifs: GifsWrapper?
    override func viewDidLoad() {
      super.viewDidLoad()
			navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addImage")	
			getInitialImages()
			
    }
	
	func getInitialImages() {
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
			Gif.getGifs( { (wrapperGifs, error) in
				self.wrapperGifs = wrapperGifs
				//				self.gifs = self.wrapperGifs!.gifs!
				let arrayGifs = self.wrapperGifs!.gifs!
				self.getThumbnailImageForCell(arrayGifs)
				
			})
		}
		
	}
	
	
	
	func getThumbnailImageForCell(gifs: [Gif]) {
		for gif in gifs {
			dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
				Gif.getThumbnailImageForGif(gif, completionHandler: { (returnGif, error) in
					self.gifs.append(returnGif!)
					self.viewCollection.reloadData()
				})
			}
		}
	}
	
	func addImage() {
		print("getetgeeeg")
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return gifs.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCell
		if (indexPath.row < gifs.count) {
			let gif = gifs[indexPath.item]
			cell.imageView.image = gif.thumbnailImage
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


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
