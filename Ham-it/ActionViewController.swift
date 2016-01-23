//
//  ActionViewController.swift
//  Ham-it
//
//  Created by Mike Sabo on 12/19/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit
import MobileCoreServices
import ReactiveCocoa

class ActionViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  var url = ""

  override func viewDidLoad() {
      super.viewDidLoad()
  
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done")
    
    if let inputItem = extensionContext!.inputItems.first as? NSExtensionItem {
      if let itemProvider = inputItem.attachments?.first as? NSItemProvider {
        itemProvider.loadItemForTypeIdentifier(kUTTypePropertyList as String, options: nil) { [unowned self] (dict, error) in
          let itemDictionary = dict as! NSDictionary
          let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary
          
          self.url = javaScriptValues["URL"] as! String
          
          dispatch_async(dispatch_get_main_queue()) {
            self.title = "Ham-it"
          }
        }
      }
    }
  }
  @IBAction func addGifToHam(sender: UILabel) {
    
  }
  
  @IBOutlet weak var messageLabel: UILabel!
  @IBAction func addGif(sender: UIButton) {
    var imgurId = ""
    if (self.url.rangeOfString("imgur", options: .RegularExpressionSearch) != nil) {
      if let match = self.url.rangeOfString("(\\w*)$", options: .RegularExpressionSearch) {
        imgurId = self.url.substringWithRange(match)
      }
    }
    
    guard imgurId.characters.count > 1 else {
     self.messageLabel.text = "Wasn't able to parse the imgur id - #failed"
      return
    }
    
    let gifService = GifService()
    gifService.addGif(id: imgurId)
      .on(next: { [weak self] response in
        if response {
          self?.messageLabel.text = "Success"
        }
    }).start()
  }

  @IBAction func done() {
      // Return any edited content to the host app.
      // This template doesn't do anything, so we just echo the passed in items.
      self.extensionContext!.completeRequestReturningItems(self.extensionContext!.inputItems, completionHandler: nil)
  }

}
