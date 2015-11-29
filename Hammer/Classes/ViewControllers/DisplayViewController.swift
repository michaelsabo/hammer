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
    var gif: Gif?
		var tags: [Tag]?
		var tagLabels: [PaddedTagLabel]? =  [PaddedTagLabel]()
		var displayGifViewModel: DisplayViewModel!
  
    var cocoaActionShare: CocoaAction?
		var shareButton: UIBarButtonItem?
  
		required init?(coder aDecoder: NSCoder) {
			super.init(coder: aDecoder)
		}

    override func viewDidLoad() {
      super.viewDidLoad()
			setupView()
			bindViewModel()
		}
	
		func setupView() {
			self.view.backgroundColor = UIColor.flatWhiteColorDark()
			self.configureNavigationBar()
			let loadingFrame = CGRectMake((Screen.screenWidth/2.0)-30, (self.imageView.frame.origin.y)+(self.imageView.frame.size.height/2)-20, 60.0, 50.0)
			let loadingView = NVActivityIndicatorView(frame: loadingFrame, type: .LineScalePulseOut, color: UIColor.flatTealColor())
			loadingView.tag = kLoadingAnimationTag
			self.view.addSubview(loadingView)
			loadingView.startAnimation()
		}
	
		func bindViewModel() {
      let shareAction = Action<Void, Void, NSError> { [unowned self] in
        self.shareButtonClicked()
        return SignalProducer.empty
      }
      cocoaActionShare = CocoaAction(shareAction, input: ())
      shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: cocoaActionShare, action: CocoaAction.selector)
      
      self.displayGifViewModel.gifRequestSignal
        .observeNext({[unowned self] observer in
          let animation = self.view.viewWithTag(kLoadingAnimationTag) as? NVActivityIndicatorView
          animation?.stopAnimation()
          animation?.removeFromSuperview()
          self.imageView.image = UIImage.animatedImageWithAnimatedGIFData(self.displayGifViewModel.gifData)
          self.navigationItem.rightBarButtonItem = self.shareButton
      })
      
      self.displayGifViewModel.tagRequestSignal
        .observeOn(UIScheduler())
        .observeNext({[unowned self] observer in
          if (self.displayGifViewModel.tags.value.count > 0) {
            self.addTagsToLabels()
          }
      })
  }
	
	func addTagsToLabels() {
    
    for tag in self.displayGifViewModel.tags.value  {
      let label = PaddedTagLabel.init(text: tag.name)
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
    self.view.setNeedsLayout()
    self.view.updateConstraintsIfNeeded()
    self.view.layoutIfNeeded()
	}
  
  func shareButtonClicked() {
    if let copiedGif = self.displayGifViewModel.gif.value.gifData {
      let vc = UIActivityViewController(activityItems: [copiedGif], applicationActivities: [])
      if (vc.respondsToSelector(Selector("popoverPresentationController"))) {
        vc.popoverPresentationController?.sourceView = self.view
        vc.popoverPresentationController?.barButtonItem = self.shareButton
      }
      presentViewController(vc, animated: true, completion: nil)
    } else {
      let ac = UIAlertController(title: "Woahhhh", message: "Something went wrong when processing. \nLet's do this again", preferredStyle: UIAlertControllerStyle.Alert)
      presentViewController(ac, animated: true, completion: nil)
    }
  }

  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillAppear(animated)
  }

  deinit {
    self.displayGifViewModel.cleanUpSignals()
		print("deiniting")
	}
}

