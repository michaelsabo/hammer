//
//  SearchView.swift
//  Hammer
//
//  Created by Mike Sabo on 1/23/16.
//  Copyright © 2016 FlyingDinosaurs. All rights reserved.
//

import UIKit

class SearchView: UIView {

  /*
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func drawRect(rect: CGRect) {
      // Drawing code
  }
  */
  
  var searchTextField:UITextField!
  var tableView:UITableView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }
  
  
  

}
