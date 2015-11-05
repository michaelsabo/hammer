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
import ReactiveCocoa

class DisplayViewController: UIViewController {

		@IBOutlet weak var imageView: UIImageView!
		weak var gifImage: UIImage?
    weak var gif: Gif?
		weak var gifData: NSData?
		var pasteBoard: UIPasteboard?
		var tags: [Tag]?
		var tagLabels: [PaddedTagLabel]? =  [PaddedTagLabel]()
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
			self.configureNavigationBar()
			let loadingFrame = CGRectMake((self.view.frame.size.width/2.0)-25, (self.imageView.frame.size.height/2)-20, 50.0, 40.0)
			let loadingView = NVActivityIndicatorView(frame: loadingFrame, type: .LineScalePulseOut, color: UIColor.flatTealColor())
			loadingView.tag = kLoadingAnimationTag
			self.view.addSubview(loadingView)
			loadingView.startAnimation()
		}
	
		func bindViewModel() {
      self.displayGifViewModel.gifRequestSignal
        .observeNext({[unowned self] sink in
          let animation = self.view.viewWithTag(kLoadingAnimationTag) as? NVActivityIndicatorView
          animation?.stopAnimation()
          animation?.removeFromSuperview()
          self.imageView.image = self.displayGifViewModel.gif.value.gifImage
      })
      
      self.displayGifViewModel.tagRequestSignal
        .observeOn(UIScheduler())
        .observeNext({[unowned self] sink in
          if (self.displayGifViewModel.tags.value.count > 0) {
            self.addTagsToLabels()
          }
      })
  }
	
	func addTagsToLabels() {
    
    for tag in self.displayGifViewModel.tags.value  {
      let label = PaddedTagLabel.init(text: tag.text)
      self.view.addSubview(label)
      label.setNeedsDisplay()
      self.tagLabels?.append(label)
    }
    var prevLabel: PaddedTagLabel?
    var count = 0

    for lbl in self.tagLabels! {
      var constraints = [NSLayoutConstraint]()
      if count == 0 {
         constraints.append(NSLayoutConstraint.init(item: lbl, attribute: .Top, relatedBy: .Equal, toItem: self.imageView, attribute: .Bottom, multiplier: 1, constant: 5))
      } else {
        constraints.append(NSLayoutConstraint.init(item: lbl, attribute: .Top, relatedBy: .Equal, toItem: prevLabel, attribute: .Bottom, multiplier: 1, constant: 2))
      }
      constraints.append(NSLayoutConstraint.init(item: lbl, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 4))
      constraints.append(NSLayoutConstraint.init(item: self.view, attribute: .RightMargin, relatedBy: .GreaterThanOrEqual, toItem: lbl, attribute: .Right, multiplier: 1, constant: 4))
      self.view.addConstraints(constraints)
      
      count++
      prevLabel = lbl
    }
    self.view.updateConstraintsIfNeeded()
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
    self.displayGifViewModel.cleanUpSignals()
		print("deiniting")
	}
}

class PaddedTagLabel : UILabel {
	
	let topInset: CGFloat = 3.0
	let bottomInset:CGFloat = 3.0
	let leftInset:CGFloat = 6.0
	let rightInset:CGFloat = 6.0
  
  convenience init(text: String) {
    self.init()
    self.font = App.font()
    self.text = text
    self.translatesAutoresizingMaskIntoConstraints = false
    self.textColor = UIColor.flatWhiteColor()
    self.backgroundColor = UIColor.flatTealColor()
    self.numberOfLines = 0
    self.layer.masksToBounds = true
    self.tag = 200
    self.lineBreakMode = NSLineBreakMode.ByWordWrapping
  }

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
