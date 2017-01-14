//
//  GIFImageView+Extensions.swift
//  Hammer
//
//  Created by Mike Sabo on 1/14/17.
//  Copyright © 2017 FlyingDinosaurs. All rights reserved.
//

import Foundation
import Gifu
import MobileCoreServices

extension GIFImageView {
  
  private struct Stored {
    static var data:Data? = nil
  }
  
  var gifData : Data? {
    get {
      return Stored.data
    } set {
      Stored.data = newValue
    }
  }
  
  public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    if (action == #selector(copy(_:))) {
      return true
    } else {
      return super.canPerformAction(action, withSender: sender)
    }
  }
  
  public override var canBecomeFirstResponder: Bool {
    return true
  }
  
  public override func copy(_ sender: Any?) {
    if let data = gifData {
      let pasteboard = UIPasteboard.general
      pasteboard.setData(data, forPasteboardType: kUTTypeGIF as String)
    }
    hideMenu()
  }
  
  public func enableLongPress() {
    var longPressImageView: UILongPressGestureRecognizer!
    longPressImageView = UILongPressGestureRecognizer(target: self, action: #selector(showMenu(_:)))
    longPressImageView.isEnabled = true
    addGestureRecognizer(longPressImageView)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideMenu))
    tapGesture.isEnabled = true
    addGestureRecognizer(tapGesture)
  }
  
  func hideMenu() {
    let menu = UIMenuController.shared
    menu.setMenuVisible(false, animated: true)
  }
  
  func showMenu(_ sender: Any?) {
    
    becomeFirstResponder()
    let menu = UIMenuController.shared
    if !menu.isMenuVisible {
      if let gesture = sender as? UILongPressGestureRecognizer {
        let point = gesture.location(in: self)
        let rect = CGRect(x: point.x, y: point.y, width: 60, height: 40)
        menu.setTargetRect(rect, in: self)
      } else {
        menu.setTargetRect(bounds, in: self)
      }
      menu.setMenuVisible(true, animated: true)
    }
  }
}
