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
import Font_Awesome_Swift
import MMPopupView



class DisplayViewController: UIViewController {

		@IBOutlet weak var imageView: UIImageView!
    var gif: Gif?
		var tags: [Tag]?
		var tagLabels: [PaddedTagLabel]? =  [PaddedTagLabel]()
		var displayGifViewModel: DisplayViewModel!
    var newTagButton : UIButton!
    var tagsAddedToView = false
  
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
      self.view.clipsToBounds = true
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
          self.displayNewTagButton()
          self.horizonalTagLayout()
      })
      
      self.displayGifViewModel.createTagRequestSignal
        .observeOn(UIScheduler())
        .observeNext({ observer in
          if (observer.boolValue == true) {
            print("Success")
          }
      })
  }
  
  func displayNewTagButton() {
    newTagButton = UIButton().newButton(withTitle: "new tag", target: self, selector: "displayTagAlert", forControlEvent: .TouchUpInside)
    newTagButton.setFAText(prefixText: "", icon: FAType.FATag, postfixText: " add new tag!", size: 16, forState: .Normal)
    newTagButton.sizeToFit()
    self.view.addSubview(newTagButton)
  }
  
  func displayTagAlert() {
    let alertConfig = MMAlertViewConfig.globalConfig()
    alertConfig.defaultTextOK = "Tag it!"
    alertConfig.defaultTextConfirm = "Tag it!"
    alertConfig.defaultTextCancel = "Ruh roh, cancel"
    let alertView = MMAlertView.init(inputTitle: "DO IT", detail: "Throw some fire on this", placeholder: "lingo here..", handler: { tagText in
      if (tagText.characters.count > 2) {
        self.displayGifViewModel.startCreateTagSignalRequest(tagText)
      }
      
    })
    alertView.attachedView = self.view
    alertView.show()
    
  }

  func horizonalTagLayout() {
    
    for tag in self.displayGifViewModel.tags.value  {
      let label = PaddedTagLabel.init(text: tag.name)
      label.setFAText(prefixText: "", icon: FAType.FATag, postfixText: " \(label.text!)", size: 16)
      self.view.addSubview(label)
      label.setNeedsDisplay()
      self.tagLabels?.append(label)
    }
    tagsAddedToView = true
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    guard tagsAddedToView else {
      return
    }
    addConstraintsForTags()
  }
  
  func addConstraintsForTags() {
    let maxWidth = Screen.screenWidth
    let xPadding : CGFloat = 4.0
    let yPadding : CGFloat = 5.0
    let zeroPadding : CGFloat = 0.0
    var rowTupleArray = [(row: 0, firstItemIndex: 0, lastItemIndex: 0, currentWidth: CGFloat(0.0))]
    
    for (index, label) in (self.tagLabels?.enumerate())! {
      let objWidth = label.frame.size.width
      
      if (index == 0) {
        self.view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .Top, relatedBy: .Equal, toItem: self.imageView, attribute: .Bottom, multiplier: 1, constant: yPadding))
        self.view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: xPadding))
        rowTupleArray[rowTupleArray.count-1].currentWidth = objWidth + xPadding
      } else {
        for (i, row) in rowTupleArray.enumerate() {
          if ((row.currentWidth + objWidth) < maxWidth) {
            let previousView = (self.tagLabels?[rowTupleArray[i].lastItemIndex])! as PaddedTagLabel
            self.view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .Top, relatedBy: .Equal, toItem: previousView, attribute: .Top, multiplier: 1, constant: zeroPadding))
            self.view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .Left, relatedBy: .Equal, toItem: previousView, attribute: .Right, multiplier: 1, constant: xPadding))
            rowTupleArray[i].currentWidth += objWidth + xPadding
            rowTupleArray[i].lastItemIndex = index
            break
          } else {
            let viewAbove = (self.tagLabels?[rowTupleArray[i].firstItemIndex])! as PaddedTagLabel
            self.view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .Top, relatedBy: .Equal, toItem: viewAbove, attribute: .Bottom, multiplier: 1, constant: yPadding))
            self.view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: xPadding))
            rowTupleArray.append((rowTupleArray.count, index, index, (objWidth + xPadding)))
            break
          }
        }
      }
    }
    
    guard self.tagLabels?.count > 0 else {
      self.view.addConstraint(NSLayoutConstraint.init(item: newTagButton, attribute: .Top, relatedBy: .Equal, toItem: self.imageView, attribute: .Bottom, multiplier: 1, constant: yPadding))
      self.view.addConstraint(NSLayoutConstraint.init(item: newTagButton, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: xPadding))
      self.view.addConstraint(NSLayoutConstraint.init(item: self.view, attribute: .Right, relatedBy: .GreaterThanOrEqual, toItem: newTagButton, attribute: .RightMargin, multiplier: 1, constant: xPadding))
      return
    }
    
    let buttonWidth = newTagButton.frame.size.width
    
    if ((rowTupleArray[rowTupleArray.count-1].currentWidth + buttonWidth) > maxWidth) {
      let labelAbove = (self.tagLabels?[rowTupleArray[rowTupleArray.count-1].firstItemIndex])! as PaddedTagLabel
      self.view.addConstraint(NSLayoutConstraint.init(item: newTagButton, attribute: .Top, relatedBy: .Equal, toItem: labelAbove, attribute: .Bottom, multiplier: 1, constant: yPadding))
      self.view.addConstraint(NSLayoutConstraint.init(item: newTagButton, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: xPadding))
      self.view.addConstraint(NSLayoutConstraint.init(item: self.view, attribute: .Right, relatedBy: .GreaterThanOrEqual, toItem: newTagButton, attribute: .RightMargin, multiplier: 1, constant: xPadding))
      
    } else {
      let lastLabel = (self.tagLabels?[rowTupleArray[rowTupleArray.count-1].lastItemIndex])! as PaddedTagLabel
      self.view.addConstraint(NSLayoutConstraint.init(item: newTagButton, attribute: .Top, relatedBy: .Equal, toItem: lastLabel, attribute: .Top, multiplier: 1, constant: zeroPadding))
      self.view.addConstraint(NSLayoutConstraint.init(item: newTagButton, attribute: .Left, relatedBy: .Equal, toItem: lastLabel, attribute: .Right, multiplier: 1, constant: xPadding))
      self.view.addConstraint(NSLayoutConstraint.init(item: self.view, attribute: .Right, relatedBy: .GreaterThanOrEqual, toItem: newTagButton, attribute: .RightMargin, multiplier: 1, constant: xPadding))
    }
    tagsAddedToView = false
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

  deinit {
    self.displayGifViewModel.cleanUpSignals()
		print("deiniting")
	}
}

