//
//  CustomizeAppViewModel.swift
//  Hammer
//
//  Created by Mike Sabo on 11/13/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation
import ReactiveCocoa
import NVActivityIndicatorView

enum CustomizeType {
  case Animation,
  NavigationBarColor,
  BackgroundColor
}

let kAnimation = "animation"
let kBackgroundColor = "backgroundColor"
let kNavigationBarColor = "navigationBarColor"


class CustomizeAppViewModel : NSObject {
  
  let colorCollection = MutableProperty<[UIColor]>([UIColor]())
  let screenType = MutableProperty<CustomizeType>(CustomizeType.Animation)
  var defaults = NSUserDefaults.standardUserDefaults()
  
  convenience init(screenType: CustomizeType) {
    self.init()
    
    self.screenType.value = screenType
    
    switch screenType {
      case .Animation:
//        self.customizeCollection.value = activityTypes
        break;
      case .NavigationBarColor:
        self.colorCollection.value = colors
        break;
      case .BackgroundColor:
        self.colorCollection.value = colors
        break;
    }
  }
  
  func currentSelectedItem() -> AnyObject? {
    switch self.screenType.value {
    case .Animation:
      return defaults.objectForKey(kAnimation)
    case .NavigationBarColor:
      return defaults.objectForKey(kNavigationBarColor)
    case .BackgroundColor:
      return defaults.objectForKey(kBackgroundColor)
    }
  }
  
  func saveSelections() {
    defaults.synchronize()
  }
  
  
  lazy var numberOfCells:  Int = {
    switch self.screenType.value {
      case .Animation:
        return self.activityTypes.count
      case .NavigationBarColor, .BackgroundColor:
        return self.colors.count
    }
  }()
  
  
  var colors:  [UIColor] = [
    UIColor.flatWhiteColor(),
    UIColor.flatWhiteColorDark(),
    UIColor.flatRedColor(),
    UIColor.flatRedColorDark(),
    UIColor.flatBlueColor(),
    UIColor.flatBlueColorDark()
  ]
  
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