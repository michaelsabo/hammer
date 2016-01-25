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

class DisplayViewController: UIViewController, UINavigationBarDelegate, UINavigationControllerDelegate {

		@IBOutlet weak var imageView: UIImageView!
    var gif: Gif?
		var tags: [Tag]?
		var tagLabels: [PaddedTagLabel]? =  [PaddedTagLabel]()
		var displayGifViewModel: DisplayViewModel!
    var newTagButton : UIButton!
    var tagsAddedToView = false
    let tagHeight:CGFloat = 34
    var cocoaActionShare: CocoaAction?
		var shareButton: UIBarButtonItem?
  
		required init?(coder aDecoder: NSCoder) {
			super.init(coder: aDecoder)
		}
  
    convenience  init() {
      self.init(nibName: "DisplayViewController", bundle: nil)
    }
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
  
    override func viewDidLoad() {
      super.viewDidLoad()
			setupView()
			bindViewModel()
		}
	
		func setupView() {
			self.view.backgroundColor = ColorThemes.getBackgroundColor()
      self.view.clipsToBounds = true
			self.configureNavigationBar()
			let loadingFrame = CGRectMake(0, 0, 60.0, 60.0)
			let loadingView = NVActivityIndicatorView(frame: loadingFrame, type: .LineScalePulseOut, color: ColorThemes.subviewsColor())
			loadingView.tag = kLoadingAnimationTag
      loadingView.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview(loadingView)
      self.view.addConstraint(NSLayoutConstraint.init(item: loadingView, attribute: .CenterY, relatedBy: .Equal, toItem: self.imageView, attribute: .CenterY, multiplier: 1, constant: 0))
      self.view.addConstraint(NSLayoutConstraint.init(item: loadingView, attribute: .CenterX, relatedBy: .Equal, toItem: self.imageView, attribute: .CenterX, multiplier: 1, constant: 0))
      self.view.addConstraint(NSLayoutConstraint.init(item: loadingView, attribute: .Width, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 60))
      self.view.addConstraint(NSLayoutConstraint.init(item: loadingView, attribute: .Height, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 60))
			loadingView.startAnimation()
		}
	
		func bindViewModel() {
      let shareAction = Action<Void, Void, NSError> { [weak self] in
        self?.shareButtonClicked()
        return SignalProducer.empty
      }
      cocoaActionShare = CocoaAction(shareAction, input: ())
      shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: cocoaActionShare, action: CocoaAction.selector)
      
      self.displayGifViewModel.gifRequestSignal
        .observeNext({[weak self] observer in
          let animation = self?.view.viewWithTag(kLoadingAnimationTag) as? NVActivityIndicatorView
          animation?.stopAnimation()
          animation?.removeFromSuperview()
          self?.displayGifViewModel.gifImage.value = UIImage.animatedImageWithAnimatedGIFData(self?.displayGifViewModel.gifData)
          self?.imageView.image = self?.displayGifViewModel.gifImage.value
          self?.navigationItem.rightBarButtonItem = self?.shareButton
      })
      
      self.displayGifViewModel.tagRequestSignal
        .observeOn(UIScheduler())
        .observeNext({[weak self] observer in
          self?.removeTagsAndButton()
          self?.displayNewTagButton()
          self?.horizonalTagLayout()
      })
      
      self.displayGifViewModel.createTagRequestSignal
        .observeOn(UIScheduler())
        .observeNext({ [weak self] observer in
          if (observer.boolValue == true) {
            UserDefaults.incrementTagsAdded()
            self?.displayGifViewModel.startTagSignal()
          }
      })
  }
  
  func removeTagsAndButton() {
    for subview in view.subviews {
      if subview.tag == 200 || subview.tag == 10005 {
        subview.removeFromSuperview()
      }
    }
  }
  
  func displayNewTagButton() {
    newTagButton = PaddedButton(frame: CGRectMake(0,0,126,tagHeight)).newButton(withTitle: "new tag", target: self, selector: "displayTagAlert", forControlEvent: .TouchUpInside)
    newTagButton.setFAText(prefixText: "", icon: FAType.FATag, postfixText: " add new tag!", size: 16, forState: .Normal)
    newTagButton.tag = 10005
    self.view.addSubview(newTagButton)
    self.view.addConstraint(NSLayoutConstraint.init(item: newTagButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: tagHeight))
    self.view.addConstraint(NSLayoutConstraint.init(item: newTagButton, attribute: .Width, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 126))
  }
  
  func displayTagAlert() {
    let alertConfig = MMAlertViewConfig.globalConfig()
    alertConfig.defaultConfig()
    alertConfig.defaultTextConfirm = "I WILL!"
    alertConfig.defaultTextCancel = "You Won't"
    let alertView = MMAlertView.init(inputTitle: "New Tag", detail: self.displayGifViewModel.alertDetail, placeholder: "lingo here..", handler: {  tagText in
      if (tagText.characters.count > 2) {
        self.displayGifViewModel.startCreateTagSignalRequest(tagText.lowercaseString)
      } else {
       
      }
    })

    alertView.attachedView = self.view
    alertView.show()
  }

  func horizonalTagLayout() {
    self.tagLabels = [PaddedTagLabel]()
    for tag in self.displayGifViewModel.tags.value  {
      let label = PaddedTagLabel.init(text: tag.name)
      label.setFAText(prefixText: "", icon: FAType.FATag, postfixText: " \(label.text!)", size: 16)
      self.view.addSubview(label)
      self.view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: tagHeight))
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
          } else if (i < rowTupleArray.count-1) {
            continue
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
    if let copiedGif =  self.displayGifViewModel.gifData {
      let vc = UIActivityViewController(activityItems: [copiedGif], applicationActivities: [])
      if (vc.respondsToSelector(Selector("popoverPresentationController"))) {
        vc.popoverPresentationController?.sourceView = self.view
        vc.popoverPresentationController?.barButtonItem = self.shareButton
      }
      vc.completionWithItemsHandler = {
        (activityType: String?, completed: Bool, items: [AnyObject]?, err:NSError?) -> Void in
        if !completed {
          return
        } else {
          UserDefaults.incrementTotalShares()
        }
      }
      presentViewController(vc, animated: true, completion: nil)
    } else {
      let ac = UIAlertController(title: "Woahhhh", message: "Something went wrong when processing. Let's do this again", preferredStyle: UIAlertControllerStyle.Alert)
      let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
      ac.addAction(okAction)
      presentViewController(ac, animated: true, completion: nil)
    }
  }

  deinit {
    self.displayGifViewModel.stopServiceSignals()
		print("deiniting")
	}
}

