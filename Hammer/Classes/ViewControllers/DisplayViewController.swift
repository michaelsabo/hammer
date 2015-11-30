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
//          self.displayNewTagButton()
          if (self.displayGifViewModel.tags.value.count > 0) {
            self.horizonalTagLayout()
          }

      })
  }
  
  func displayNewTagButton() {
    newTagButton = UIButton()
    newTagButton.titleLabel?.font = App.font()
    newTagButton.setTitle("add a new tag", forState: .Normal)
    newTagButton.setTitleColor(UIColor.flatWhiteColor(), forState: .Normal)
    newTagButton.backgroundColor = UIColor.flatTealColor()
    newTagButton.setFAText(prefixText: "", icon: FAType.FATag, postfixText: "  Add new tag!", size: 18, forState: .Normal)
    newTagButton.titleLabel?.font = App.font()
    newTagButton.contentEdgeInsets = UIEdgeInsets(top: 3.0, left: 6.0, bottom: 3.0, right: 6.0)
    newTagButton.translatesAutoresizingMaskIntoConstraints = false
    newTagButton.layer.cornerRadius = 5.0
    
    self.view.addSubview(newTagButton)
    self.view.addConstraint(NSLayoutConstraint.init(item: newTagButton, attribute: .Top, relatedBy: .Equal, toItem: self.imageView, attribute: .Bottom, multiplier: 1, constant: 3))
    self.view.addConstraint(NSLayoutConstraint.init(item: newTagButton, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 4))
    self.view.addConstraint(NSLayoutConstraint.init(item: self.view, attribute: .RightMargin, relatedBy: .GreaterThanOrEqual, toItem: newTagButton, attribute: .Right, multiplier: 1, constant: 4))
  }

  func horizonalTagLayout() {
    for tag in self.displayGifViewModel.tags.value  {
      let label = PaddedTagLabel.init(text: tag.name)
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
    var currentX : CGFloat = 0
    
    var indexesOfFirstItemInRow : [Int] = [0]
    var indexOfLastItemInRow : [Int] = [0]
    var rowCurrentWidth : [CGFloat] = [0]
    var numberOfRows = 1
    
    for (index, label) in (self.tagLabels?.enumerate())! {
      let objWidth = label.frame.size.width
      
      if (index == 0) {
        self.view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .Top, relatedBy: .Equal, toItem: self.imageView, attribute: .Bottom, multiplier: 1, constant: yPadding))
        self.view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: xPadding))
        
        rowCurrentWidth[numberOfRows-1] = objWidth + xPadding
        
      } else {
        for (i, width) in rowCurrentWidth.enumerate() {
          if ((width + objWidth) < maxWidth) {
            let previousView = (self.tagLabels?[indexOfLastItemInRow[i]])! as PaddedTagLabel
            self.view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .Top, relatedBy: .Equal, toItem: previousView, attribute: .Top, multiplier: 1, constant: zeroPadding))
            self.view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .Left, relatedBy: .Equal, toItem: previousView, attribute: .Right, multiplier: 1, constant: xPadding))
            
            indexOfLastItemInRow[i] = index
            rowCurrentWidth[i] += objWidth + xPadding
            break
          } else {
            let viewAbove = (self.tagLabels?[indexesOfFirstItemInRow.last!])! as PaddedTagLabel
            self.view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .Top, relatedBy: .Equal, toItem: viewAbove, attribute: .Bottom, multiplier: 1, constant: yPadding))
            self.view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: xPadding))
            indexesOfFirstItemInRow.append(index)
            indexOfLastItemInRow.append(index)
            rowCurrentWidth.append((objWidth + xPadding))
            numberOfRows += 1
            break
          }
        }
      }
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

  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillAppear(animated)
  }

  deinit {
    self.displayGifViewModel.cleanUpSignals()
		print("deiniting")
	}
}

