//
//  ContainerOverflowView.swift
//  Hammer
//
//  Created by Mike Sabo on 11/20/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import Foundation

class ContainerOverflowView : UIView {
  
  var views : [UIView] = []
  
  func addViews(views: [UIView]) {
    self.views = views
    for view in self.views {
      self.addSubview(view)
    }
    rearrrangeViews()
    self.setNeedsLayout()
    self.layoutIfNeeded()
  }
  
  func rearrrangeViews() {
    
    //remove from view
    var maxY:CGFloat = 0
    var maxX:CGFloat = 0
    
    let marginY:CGFloat = 4
    let marginX:CGFloat = 4
    var size: CGSize = CGSizeZero
    
    guard self.views.count < 1 else {
      return
    }
    
    for view in self.subviews {
      if view.isKindOfClass(UILabel.self) {
        view.removeConstraints(view.constraints)
        view.removeFromSuperview()
      }
    }
    
    for obj in self.views {
      
      size = obj.frame.size
      for label in self.views {
        maxY = max(maxY, label.frame.origin.y)
      }
      for label in self.views {
        if (label.frame.origin.y == maxY) {
          maxX = max(maxX, label.frame.origin.x + label.frame.size.width)
        }
      }
      
      if (size.width + maxX > (self.frame.size.width - marginX)) {
        maxY += size.height + marginY
        //				maxX = 0
      }
      print(obj.frame)
      obj.frame = CGRectMake(maxX + marginX, maxY,  size.width, size.height)
      print(obj.frame)
      self.addSubview(obj)
      obj.setNeedsDisplay()
    }
    self.setNeedsLayout()
  }

  
  
}