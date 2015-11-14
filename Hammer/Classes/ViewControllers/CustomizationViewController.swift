//
//  ChooseAnimationViewController.swift
//  Hammer
//
//  Created by Mike Sabo on 11/8/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit
import ChameleonFramework
import NVActivityIndicatorView

class ChooseAnimationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  @IBOutlet weak var animationCollection: UICollectionView!
  var selectedIndex : NSIndexPath?
  var animationArray = [AnimationModel?]()
  
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
     super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func initialize() {
    self.animationCollection.registerClass(AnimationCell.self, forCellWithReuseIdentifier: "AnimationCell")
    if (Screen.screenWidth > 400) {
      animationCollection.collectionViewLayout = LargeCollectionViewLayout()
    } else if (Screen.screenWidth > 350) {
      animationCollection.collectionViewLayout = MediumCollectionViewLayout()
    } else {
      animationCollection.collectionViewLayout = SmallCollectionViewLayout()
    }
    animationCollection.allowsMultipleSelection = false
    animationCollection.backgroundColor = UIColor.flatWhiteColorDark()
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
   	animationCollection.reloadData()
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return activityTypes.count
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return CGSizeMake(Screen.screenWidth, 40);
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnimationCell", forIndexPath: indexPath) as! AnimationCell
    
    if animationArray.count > indexPath.item {
      if let foundAnimation = animationArray[indexPath.item] {
        cell.setBorder()
        cell.reloadAnimation(foundAnimation.animationView)
        return cell
      } else {
        
      }
    } else {
      cell.removeAnimation()
      cell.animationModel.animationView = nil
      let view = NVActivityIndicatorView(frame: cell.contentView.frame, type: activityTypes[indexPath.item],  color: UIColor.flatTealColor())
      cell.initialize(indexPath.item)
      cell.setAnimation(view)
      animationArray.insert(cell.animationModel, atIndex: indexPath.item)
    }
    return cell
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		animationCollection.reloadItemsAtIndexPaths(animationCollection.indexPathsForVisibleItems())
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    var model = animationArray[indexPath.item]
		let cell = collectionView.cellForItemAtIndexPath(indexPath) as! AnimationCell
    model?.selected = true
    cell.setBorder()
  }
  
  func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    var model = animationArray[indexPath.item]
    if let cell = collectionView.cellForItemAtIndexPath(indexPath) as! AnimationCell? {
      model?.selected = false
      cell.setBorder()
    }
  }
	
  
  let activityTypes: [NVActivityIndicatorType] = [
    .BallPulse,
    .BallGridPulse,
    .BallClipRotate,
    .BallClipRotatePulse,
    .SquareSpin,
    .BallClipRotateMultiple,
    .BallPulseRise,
    .BallRotate,
    .CubeTransition,
    .BallZigZag,
    .BallZigZagDeflect,
    .BallTrianglePath,
    .BallScale,
    .LineScale,
    .LineScaleParty,
    .BallScaleMultiple,
    .BallPulseSync,
    .BallBeat,
    .LineScalePulseOut,
    .LineScalePulseOutRapid,
    .BallScaleRipple,
    .BallScaleRippleMultiple,
    .BallSpinFadeLoader,
    .LineSpinFadeLoader,
    .TriangleSkewSpin,
    .Pacman,
    .BallGridBeat,
    .SemiCircleSpin]
	
}

struct AnimationModel {
  var hasLoaded = false
  var selected = false
  var animationView: NVActivityIndicatorView?
  var item : Int?
  init() {
    self.hasLoaded = false
    self.animationView = nil
  }
}

class AnimationCell : UICollectionViewCell {
  var hasLoaded = false
  var animationView: UIView?
  var animationModel : AnimationModel = {
    return AnimationModel()
  }()
  
  func initialize(item: Int) {
    self.animationModel.item = item
//    setBorder(false)
    setBorderColor()
    self.layer.borderWidth = 2.0
    self.selectedBackgroundView?.layer.borderWidth = 7.0
  }
  
  func setBorderColor() {
    self.layer.masksToBounds = true
    self.backgroundColor = UIColor.flatWhiteColorDark()
    self.layer.borderColor = UIColor.flatTealColor().CGColor
    self.layer.cornerRadius = 10.0
    self.selectedBackgroundView?.backgroundColor = UIColor.flatWhiteColorDark()
    self.selectedBackgroundView?.layer.borderColor = UIColor.flatTealColor().CGColor
    self.selectedBackgroundView?.layer.cornerRadius = 10.0
  }
  
  func reloadAnimation(animation: NVActivityIndicatorView?) {
    for animation in self.subviews {
      if animation.isKindOfClass(NVActivityIndicatorView){
        animation.removeFromSuperview()
      }
    }
    self.animationView = nil
		self.animationModel.animationView = animation
    self.animationView = animation
    self.addSubview(self.animationView!)
    self.animationView?.hidden = false
    self.animationModel.animationView?.startAnimation()

    self.layoutSubviews()

  }
  func removeAnimation() {
    for animation in self.subviews {
      if animation.isKindOfClass(NVActivityIndicatorView){
        animation.removeFromSuperview()
      }
    }
    self.animationModel.animationView?.stopAnimation()
    self.animationView = nil
  }
  
  func setAnimation(animation: NVActivityIndicatorView?) {
    self.animationModel.animationView = animation
    self.animationModel.hasLoaded = true
    self.animationView = self.animationModel.animationView!
    self.addSubview(self.animationView!)
    self.animationModel.animationView?.startAnimation()
  }
  
  func setBorder() {
    setBorderColor()
    if (self.selected) {
      self.layer.borderWidth = 7.0
    } else {
      self.layer.borderWidth = 2.0
    }
  }
  
  
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.animationView = nil
  }

}
