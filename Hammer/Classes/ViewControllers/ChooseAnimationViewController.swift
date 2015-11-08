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
  
  func initialize() {

    
    if (Screen.screenWidth > 400) {
      animationCollection.collectionViewLayout = LargeCollectionViewLayout.init()
    } else if (Screen.screenWidth > 350) {
      animationCollection.collectionViewLayout = MediumCollectionViewLayout.init()
    } else {
      animationCollection.collectionViewLayout = SmallCollectionViewLayout.init()
    }
    animationCollection.allowsMultipleSelection = false
    animationCollection.backgroundColor = UIColor.flatWhiteColorDark()
    animationCollection.registerClass(AnimationCell.self, forCellWithReuseIdentifier: "AnimationCell")
  }
  

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
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
  
  
//  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//    print("index path item -> \(indexPath.item)")
//    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnimationCell", forIndexPath: indexPath) as! AnimationCell
//    
//    cell.reloadAnimation()
//    print("animation model item \(cell.animationModel.item)")
//    if (cell.animationModel.hasLoaded == false) {
//      cell.initialize(indexPath.item)
//      var animationView : NVActivityIndicatorView? = nil
//      animationView = NVActivityIndicatorView(frame: cell.contentView.frame, type: activityTypes[indexPath.item],  color: UIColor.flatTealColor())
//      animationView?.translatesAutoresizingMaskIntoConstraints = true
//      animationView?.layer.masksToBounds = true
//      cell.setAnimation(animationView)
//    }
//    if (cell.selected) {
//      cell.layer.borderWidth = 7.0
//    } else {
//      cell.layer.borderWidth = 2.0
//    }
//    return cell
//  }
  
  var animationArray = [AnimationModel?]()
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnimationCell", forIndexPath: indexPath) as! AnimationCell
    
    if animationArray.count > indexPath.item {
      
      if let foundAnimation = animationArray[indexPath.item] {
        cell.reloadAnimation(foundAnimation.animationView)
        if (foundAnimation.animationView == nil) {
          print("FUCKKKK")
        }
        return cell
      } else {
        print("why am i here")
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
		let cell = collectionView.cellForItemAtIndexPath(indexPath) as! AnimationCell
    cell.selected = true
		cell.performSelectionAnimations()
  }
  
  func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! AnimationCell
    cell.selected = false
    cell.removeBorder()
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
    self.backgroundColor = UIColor.flatWhiteColorDark()
    self.layer.borderColor = UIColor.flatTealColor().CGColor
    self.layer.cornerRadius = 10.0
    self.layer.borderWidth = 2.0
    self.layer.masksToBounds = true
    self.animationModel.item = item
  }
  
  func reloadAnimation(animation: NVActivityIndicatorView?) {
    for animation in self.subviews {
      if animation.isKindOfClass(NVActivityIndicatorView){
        animation.removeFromSuperview()
      }
    }
    removeBorder()
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
  
  func performSelectionAnimations() {
    self.layer.borderWidth = 7.0
    self.layer.cornerRadius = 10.0
  }
  func removeBorder() {
    self.layer.borderWidth = 2.0
    self.layer.cornerRadius = 10.0
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.animationView = nil
  }

}
