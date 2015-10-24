//
//  DisplayViewController.swift
//  Hammer
//
//  Created by Mike Sabo on 10/5/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit
import MobileCoreServices
import ChameleonFramework
import NVActivityIndicatorView

class DisplayViewController: UIViewController {

		@IBOutlet weak var imageView: UIImageView!
		var gifImage: UIImage?
	  var gif: Gif?
		var gifData: NSData?
		var pasteBoard: UIPasteboard?
		var tags: [Tag]?
	
		@IBOutlet weak var tagsViewContainer: UIView!
	
    override func viewDidLoad() {
      super.viewDidLoad()
			navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "copyImageToClipboard")
			self.view.backgroundColor = UIColor.flatWhiteColorDark()
			self.navigationController?.navigationBar.barTintColor = UIColor.flatTealColor()
			self.navigationController?.navigationBar.tintColor = UIColor.flatWhiteColor()
			let loadingFrame = CGRectMake((self.view.frame.size.width/2.0)-25, (self.imageView.frame.size.height/2)-20, 50.0, 40.0)
			let loadingView = NVActivityIndicatorView(frame: loadingFrame, type: .LineScalePulseOut, color: UIColor.flatTealColor())
			loadingView.tag = 100
			self.view.addSubview(loadingView)
			loadingView.startAnimation()
			if (gif != nil) {
					getGifImage()
					getTagsForImage()
			}
		}
	
	
		func displayGif(image: UIImage) {
			if (gif != nil) {
			dispatch_async(dispatch_get_main_queue()) { [unowned self] in
				let loader = self.view.viewWithTag(100) as? NVActivityIndicatorView
				loader?.stopAnimation()
				loader?.removeFromSuperview()
				self.gifImage = image
				self.imageView.image = image
				self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
				self.imageView.translatesAutoresizingMaskIntoConstraints = false
				self.imageView.clipsToBounds = true
				}
			}
		}
	
		func getGifImage() {
			if let gifData = gif {
				dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
					Gif.getAnimatedGifDataForUrl(gifData.url, completionHandler: { [unowned self] (imageData, isSuccess, error) in
						if (isSuccess) {
							self.gifData = imageData!
							self.displayGif(UIImage.animatedImageWithAnimatedGIFData(imageData!))
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
		if let tagsList = tags {
			dispatch_async(dispatch_get_main_queue()) { [unowned self] in
				var labelDictionary:[String: AnyObject] = ["imageView": self.imageView]
				var labelArray = [String]()
				var count = 0

						for tag in tagsList  {
							let label = PaddedTagLabel()
							label.text = tag.text
							label.translatesAutoresizingMaskIntoConstraints = false
							label.backgroundColor = UIColor.grayColor()
							label.frame.size = CGSize(width: 40, height: 20)
							label.numberOfLines = 0
							self.view.addSubview(label)
							labelArray.append("label\(count)")
							let labelName = "label\(count)"
							labelDictionary[labelName] = label
							let constraint = NSLayoutConstraint.init(item: label, attribute: .Top, relatedBy: .Equal, toItem: self.imageView, attribute: .Bottom, multiplier: 1, constant: 0)
							self.view.addConstraint(constraint)
							count++
						}
						var labelHorizontalLayout = "-5-"
						for label in labelArray {
							labelHorizontalLayout += "["  + label +  "]-"
						}
						if (labelArray.count > 0) {
							self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|\(labelHorizontalLayout)>=5-|", options: [], metrics: nil, views: labelDictionary))
						}
			}
		}
	}
	
		func copyImageToClipboard() {
			var pasteboard: UIPasteboard?
			if gifData != nil {
			 pasteboard = UIPasteboard.generalPasteboard()
				pasteboard!.persistent = true
				pasteboard!.setData(gifData!, forPasteboardType: kUTTypeGIF as String)
			} else {
				print("nothing to copy")
			}
		}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		self.gif = nil
		self.tags = nil
	}

	deinit {
		gifImage = nil
		gif = nil
		tags = nil
	}
}

class PaddedTagLabel : UILabel {
	
	let topInset: CGFloat = 3.0
	let bottomInset:CGFloat = 3.0
	let leftInset:CGFloat = 6.0
	let rightInset:CGFloat = 6.0
	
	override func drawTextInRect(rect: CGRect) {
		let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
		self.setNeedsLayout()
		return super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
	}
	
	override func intrinsicContentSize() -> CGSize {
		var intrinsicSuperViewContentSize = super.intrinsicContentSize()
		intrinsicSuperViewContentSize.height += bottomInset + topInset
		intrinsicSuperViewContentSize.width += leftInset + rightInset
		return intrinsicSuperViewContentSize
	}
	

}
