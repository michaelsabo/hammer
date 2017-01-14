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
import RxSwift
import RxCocoa
import Regift
import Gifu
import Font_Awesome_Swift
import MMPopupView
import BonMot

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class DisplayViewController: UIViewController, UINavigationBarDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var imageView: GIFImageView!
  
  @IBOutlet weak var videoSizeLabel: UILabel! {
    didSet {
      videoSizeLabel.isHidden = true
    }
  }
  @IBOutlet weak var gifSizeLabel: UILabel! {
    didSet {
      gifSizeLabel.isHidden = true
    }
  }
  
  var tags: [Tag]?
  var tagLabels: [PaddedTagLabel]? =  [PaddedTagLabel]()
  var displayGifViewModel: DisplayViewModel!
  var newTagButton : UIButton!
  var tagsAddedToView = false
  let tagHeight:CGFloat = 34

  var shareButton: UIBarButtonItem?
  var disposeBag:DisposeBag! = DisposeBag()

  var videoSize:Int = 0
  var gifVideoSize:Int = 0
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  convenience init() {
    self.init(nibName: "DisplayViewController", bundle: nil)
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    
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
    let loadingFrame = CGRect(x: 0, y: 0, width: 60.0, height: 60.0)
    let loadingView = NVActivityIndicatorView(frame: loadingFrame, type: .lineScalePulseOut, color: ColorThemes.subviewsColor())
    loadingView.tag = kLoadingAnimationTag
    loadingView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(loadingView)
    self.view.addConstraint(NSLayoutConstraint.init(item: loadingView, attribute: .centerY, relatedBy: .equal, toItem: self.imageView, attribute: .centerY, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint.init(item: loadingView, attribute: .centerX, relatedBy: .equal, toItem: self.imageView, attribute: .centerX, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint.init(item: loadingView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60))
    self.view.addConstraint(NSLayoutConstraint.init(item: loadingView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60))
    loadingView.startAnimating()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  func bindViewModel() {

    shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(DisplayViewController.shareButtonClicked))

    self.displayGifViewModel.gifRequestSignal
      .asObservable()
      .filter({$0})
      .observeOn(MainScheduler.instance)
      .subscribe({  [weak self] _ in
        guard let selfie = self else { return }
        let animation = selfie.view.viewWithTag(kLoadingAnimationTag) as? NVActivityIndicatorView
        animation?.stopAnimating()
        animation?.removeFromSuperview()
        selfie.imageView.prepareForAnimation(withGIFData: selfie.displayGifViewModel.gifData)
        selfie.imageView.startAnimatingGIF()
        selfie.imageView.gifData = selfie.displayGifViewModel.gifData
        selfie.imageView.isUserInteractionEnabled = true
        selfie.navigationItem.rightBarButtonItem = selfie.shareButton
        selfie.videoSizeLabel.isHidden = false
        selfie.videoSizeLabel.attributedText = "download size: \(selfie.displayGifViewModel.videoSize.fileSize)".styled(with:ColorThemes.fileInfoStyle())
        selfie.gifSizeLabel.isHidden = false
        selfie.gifSizeLabel.attributedText = "gif size: \(selfie.displayGifViewModel.gifData.count.fileSize)".styled(with:ColorThemes.fileInfoStyle())
        selfie.imageView.enableLongPress()
      }).addDisposableTo(disposeBag)
      
      
    self.displayGifViewModel.tagRequestSignal
      .asObservable()
      .subscribeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        guard let selfie = self else { return }
        selfie.removeTagsAndButton()
        selfie.displayNewTagButton()
        selfie.horizonalTagLayout()
      }).addDisposableTo(disposeBag)
    
    self.displayGifViewModel.createTagRequestSignal
      .asObservable()
      .subscribeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] success in
        if (success) {
          UserDefaults.incrementTagsAdded()
          self?.displayGifViewModel.startTagSignal()
        }
    }).addDisposableTo(disposeBag)
  }
  
  func removeTagsAndButton() {
    for subview in view.subviews {
      if subview.tag == 200 || subview.tag == 10005 {
        subview.removeFromSuperview()
      }
    }
  }
  
  func displayNewTagButton() {
    newTagButton = PaddedButton(frame: CGRect(x: 0,y: 0,width: 126,height: tagHeight)).newButton(withTitle: "new tag", target: self, selector: #selector(DisplayViewController.displayTagAlert), forControlEvent: .touchUpInside)
    newTagButton.setFAText(prefixText: "", icon: FAType.FATag, postfixText: " add new tag!", size: 16, forState: .normal)
    newTagButton.tag = 10005
    self.view.addSubview(newTagButton)
    self.view.addConstraint(NSLayoutConstraint.init(item: newTagButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: tagHeight))
    self.view.addConstraint(NSLayoutConstraint.init(item: newTagButton, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 126))
  }
  
  func displayTagAlert() {
    let alertConfig = MMAlertViewConfig.global()
    alertConfig?.defaultConfig()
    alertConfig?.defaultTextConfirm = "I WILL!"
    alertConfig?.defaultTextCancel = "You Won't"
    let alertView = MMAlertView.init(inputTitle: "New Tag", detail: self.displayGifViewModel.alertDetail, placeholder: "lingo here..", handler: {  tagText in
      if (tagText?.characters.count > 2) {
        self.displayGifViewModel.startCreateTagSignalRequest((tagText?.lowercased())!)
      } else {
       
      }
    })

    alertView?.attachedView = self.view
    alertView?.show()
  }

  func horizonalTagLayout() {
    self.tagLabels = [PaddedTagLabel]()
    for tag in self.displayGifViewModel.tags.value  {
      let label = PaddedTagLabel.init(text: tag.name)
      label.setFAText(prefixText: "", icon: FAType.FATag, postfixText: " \(label.text!)", size: 16)
      self.view.addSubview(label)
      self.view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: tagHeight))
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
    
    for (index, label) in (self.tagLabels?.enumerated())! {
      let objWidth = label.frame.size.width
      
      if (index == 0) {
        self.view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .top, relatedBy: .equal, toItem: self.videoSizeLabel, attribute: .bottom, multiplier: 1, constant: yPadding))
        self.view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: xPadding))
        rowTupleArray[rowTupleArray.count-1].currentWidth = objWidth + xPadding
      } else {
        for (i, row) in rowTupleArray.enumerated() {
          if ((row.currentWidth + objWidth) < maxWidth) {
            let previousView = (self.tagLabels?[rowTupleArray[i].lastItemIndex])! as PaddedTagLabel
            self.view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .top, relatedBy: .equal, toItem: previousView, attribute: .top, multiplier: 1, constant: zeroPadding))
            self.view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .left, relatedBy: .equal, toItem: previousView, attribute: .right, multiplier: 1, constant: xPadding))
            rowTupleArray[i].currentWidth += objWidth + xPadding
            rowTupleArray[i].lastItemIndex = index
            break
          } else if (i < rowTupleArray.count-1) {
            continue
          } else {
            let viewAbove = (self.tagLabels?[rowTupleArray[i].firstItemIndex])! as PaddedTagLabel
            self.view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .top, relatedBy: .equal, toItem: viewAbove, attribute: .bottom, multiplier: 1, constant: yPadding))
            self.view.addConstraint(NSLayoutConstraint.init(item: label, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: xPadding))
            rowTupleArray.append((rowTupleArray.count, index, index, (objWidth + xPadding)))
            break
          }
        }
      }
    }
    
    guard self.tagLabels?.count > 0 else {
      self.view.addConstraint(NSLayoutConstraint.init(item: newTagButton, attribute: .top, relatedBy: .equal, toItem: self.videoSizeLabel, attribute: .bottom, multiplier: 1, constant: yPadding))
      self.view.addConstraint(NSLayoutConstraint.init(item: newTagButton, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: xPadding))
      self.view.addConstraint(NSLayoutConstraint.init(item: self.view, attribute: .right, relatedBy: .greaterThanOrEqual, toItem: newTagButton, attribute: .rightMargin, multiplier: 1, constant: xPadding))
      return
    }
    
    let buttonWidth = newTagButton.frame.size.width
    
    if ((rowTupleArray[rowTupleArray.count-1].currentWidth + buttonWidth) > maxWidth) {
      let labelAbove = (self.tagLabels?[rowTupleArray[rowTupleArray.count-1].firstItemIndex])! as PaddedTagLabel
      self.view.addConstraint(NSLayoutConstraint.init(item: newTagButton, attribute: .top, relatedBy: .equal, toItem: labelAbove, attribute: .bottom, multiplier: 1, constant: yPadding))
      self.view.addConstraint(NSLayoutConstraint.init(item: newTagButton, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: xPadding))
      self.view.addConstraint(NSLayoutConstraint.init(item: self.view, attribute: .right, relatedBy: .greaterThanOrEqual, toItem: newTagButton, attribute: .rightMargin, multiplier: 1, constant: xPadding))
      
    } else {
      let lastLabel = (self.tagLabels?[rowTupleArray[rowTupleArray.count-1].lastItemIndex])! as PaddedTagLabel
      self.view.addConstraint(NSLayoutConstraint.init(item: newTagButton, attribute: .top, relatedBy: .equal, toItem: lastLabel, attribute: .top, multiplier: 1, constant: zeroPadding))
      self.view.addConstraint(NSLayoutConstraint.init(item: newTagButton, attribute: .left, relatedBy: .equal, toItem: lastLabel, attribute: .right, multiplier: 1, constant: xPadding))
      self.view.addConstraint(NSLayoutConstraint.init(item: self.view, attribute: .right, relatedBy: .greaterThanOrEqual, toItem: newTagButton, attribute: .rightMargin, multiplier: 1, constant: xPadding))
    }
    tagsAddedToView = false
  }
  
  func shareButtonClicked() {
    if let copiedGif =  self.displayGifViewModel.gifData {
      let vc = UIActivityViewController(activityItems: [copiedGif], applicationActivities: [])
      if (vc.responds(to: #selector(getter: UIViewController.popoverPresentationController))) {
        vc.popoverPresentationController?.sourceView = self.view
        vc.popoverPresentationController?.barButtonItem = self.shareButton
      }
      vc.completionWithItemsHandler = { activityType, completed, items, error in
        if !completed {
          return
        } else {
          UserDefaults.incrementTotalShares()
        }
      }
      present(vc, animated: true, completion: nil)
    } else {
      let ac = UIAlertController(title: "Woahhhh", message: "Something went wrong when processing. Let's do this again", preferredStyle: UIAlertControllerStyle.alert)
      let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: nil)
      ac.addAction(okAction)
      present(ac, animated: true, completion: nil)
    }
  }

  deinit {
    self.displayGifViewModel.stopServiceSignals()
		print("deiniting")
	}
}
