//
//  DisplayViewController.swift
//  Hammer
//
//  Created by Mike Sabo on 10/5/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit

class DisplayViewController: UIViewController {

		@IBOutlet weak var imageView: UIImageView!
		var gifImage: UIImage?
	  var gif: Gif?
	
    override func viewDidLoad() {
        super.viewDidLoad()

//				imageView.image = gif.thumbnailImage
				getGifImage()
    }
	
		func displayGif(image: UIImage) {
			dispatch_async(dispatch_get_main_queue()) { [unowned self] in
				self.imageView.image = image
				self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
				self.imageView.translatesAutoresizingMaskIntoConstraints = false

				var frame = self.imageView.frame
				frame.size = self.imageView.image!.size
				self.imageView.frame = frame
			}
		}
	
		func getGifImage() {
			if let gifData = gif {
				dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
					Gif.getAnimatedGifForUrl(gifData.url, completionHandler: { [unowned self] (image, error) in
						self.displayGif(image!)
					})
				}
			}
			

			


		}
}
