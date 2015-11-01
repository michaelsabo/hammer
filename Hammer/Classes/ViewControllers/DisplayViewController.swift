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
		weak var gifImage: UIImage?
    weak var gif: Gif?
		weak var gifData: NSData?
		var pasteBoard: UIPasteboard?
		var tags: [Tag]?
	
		var displayGifViewModel: DisplayViewModel!
	
		required init?(coder aDecoder: NSCoder) {
			super.init(coder: aDecoder)
		}

    override func viewDidLoad() {
      super.viewDidLoad()
			setupView()
			bindViewModel()
		}
	
		func setupView() {
			navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "copyImageToClipboard")
			self.view.backgroundColor = UIColor.flatWhiteColorDark()
			self.navigationController?.navigationBar.barTintColor = UIColor.flatTealColor()
			self.navigationController?.navigationBar.tintColor = UIColor.flatWhiteColor()
			let loadingFrame = CGRectMake((self.view.frame.size.width/2.0)-25, (self.imageView.frame.size.height/2)-20, 50.0, 40.0)
			let loadingView = NVActivityIndicatorView(frame: loadingFrame, type: .LineScalePulseOut, color: UIColor.flatTealColor())
			loadingView.tag = kLoadingAnimationTag
			self.view.addSubview(loadingView)
			loadingView.startAnimation()
		}
	
		func bindViewModel() {
			self.displayGifViewModel.imageReturned.producer
				.take(1)
				.startWithNext({[unowned self] sink in
					if (self.displayGifViewModel.searchComplete.value == true) {
								let animation = self.view.viewWithTag(kLoadingAnimationTag) as? NVActivityIndicatorView
								animation?.stopAnimation()
								animation?.removeFromSuperview()
							self.imageView.image = self.displayGifViewModel.gif.value.gifImage
						
					}
			})
			
			self.displayGifViewModel.tags.producer
				.startWithNext({ [unowned self] _ in
				if (self.displayGifViewModel.tags.value.count > 0) {
					self.addTagsToLabels()
				}
			})
			

		}
	
	func addTagsToLabels() {
      var labelDictionary:[String: AnyObject] = ["imageView": self.imageView]
			var labelArray = [String]()
			var count = 0
			for tag in self.displayGifViewModel.tags.value  {
				let label = PaddedTagLabel()
				label.text = tag.text
				label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.flatWhiteColor()
				label.backgroundColor = UIColor.flatTealColor()
				label.numberOfLines = 0
				label.layer.masksToBounds = true
				label.lineBreakMode = NSLineBreakMode.ByWordWrapping
				self.view.addSubview(label)
				label.setNeedsLayout()
				labelArray.append("label\(count)")
				let labelName = "label\(count)"
				labelDictionary[labelName] = label
				let constraint = NSLayoutConstraint.init(item: label, attribute: .Top, relatedBy: .Equal, toItem: self.imageView, attribute: .Bottom, multiplier: 1, constant: 5)
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
			self.view.layoutIfNeeded()
	}
	
	func copyImageToClipboard() {
		let pasteboard = UIPasteboard.generalPasteboard()
		pasteboard.persistent = true
		if let copiedGif = self.displayGifViewModel.gif.value.gifData {
			pasteboard.setData(copiedGif, forPasteboardType: kUTTypeGIF as String)
		}

	}
	
  override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
	}

	deinit {
		print("deiniting")
	}
}

class PaddedTagLabel : UILabel {
	
	let topInset: CGFloat = 3.0
	let bottomInset:CGFloat = 3.0
	let leftInset:CGFloat = 6.0
	let rightInset:CGFloat = 6.0
	
	override func drawTextInRect(rect: CGRect) {
		let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
		self.layer.cornerRadius = 5.0
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
