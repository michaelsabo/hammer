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
		var pasteBoard: UIPasteboard?
		var tags: [Tag]?
	
		@IBOutlet weak var tagsViewContainer: UIView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
				navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "copyImageToClipboard")
//				view.addSubview(tagsViewContainer)
				if (gif != nil) {
					getGifImage()
					getTagsForImage()
			}
		}
	
	
		func displayGif(image: UIImage) {
			dispatch_async(dispatch_get_main_queue()) { [unowned self] in
				self.gifImage = image
				self.imageView.image = image
				self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
				self.imageView.translatesAutoresizingMaskIntoConstraints = false
				self.imageView.clipsToBounds = true
//				let viewsDictionary = ["imageView": self.imageView, "tagView":self.tagsViewContainer]
				
//				self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[imageView]-0-[tagView]", options: [], metrics: nil, views: viewsDictionary))
			}
		}
	
		func getGifImage() {
			if let gifData = gif {
				dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
					Gif.getAnimatedGifForUrl(gifData.url, completionHandler: { [unowned self] (image, isSuccess, error) in
						if (isSuccess) {
							self.displayGif(image!)
						}
					})
				}
			}
		}
	
		func getTagsForImage() {
			dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), {
				TagWrapper.getTagsForImageId((self.gif?.id)!, completionHandler: { [unowned self] (tags, isSuccess, error) in
					if (isSuccess) {
						self.tags = tags
						self.addTagsToLabels()
					}
				})
			})
		}
	
	func addTagsToLabels() {
		tagsViewContainer.translatesAutoresizingMaskIntoConstraints = false
		var labelDictionary:[String: AnyObject] = ["imageView": imageView]
		var labelArray = [String]()
		var count = 0
		for tag in tags!  {
			let label = UILabel()
			label.text = tag.text
			label.translatesAutoresizingMaskIntoConstraints = false
			label.backgroundColor = UIColor.grayColor()
			label.frame.size = CGSize(width: 40, height: 20)
			tagsViewContainer.addSubview(label)
			labelArray.append("label\(count)")
			let labelName = "label\(count)"
			labelDictionary[labelName] = label
			view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[imageView]-[\(labelName)]", options: [], metrics: nil, views: labelDictionary))
			count++
		}
		var labelHorizontalLayout = ""
		for label in labelArray {
			labelHorizontalLayout += "-5-[" + label + "]"
		}
		if (labelArray.count > 0) {
			view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|\(labelHorizontalLayout)->=50-|", options: [], metrics: nil, views: labelDictionary))
		}
		
		
		
	}
	
		func copyImageToClipboard() {
			var pasteboard: UIPasteboard?
			if gifImage != nil {
			 pasteboard = UIPasteboard.init(name: "HammerGid", create: true)
				pasteboard!.persistent = true
				pasteboard!.image = gifImage!;
			} else {
				print("nothing to copy")
			}
		}
	
	deinit {
		gifImage = nil
		gif = nil
		tags = nil
	}
}
