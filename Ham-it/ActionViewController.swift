//
//  ActionViewController.swift
//  Ham-it
//
//  Created by Mike Sabo on 12/19/15.
//  Copyright © 2015 FlyingDinosaurs. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  var url = ""

  override func viewDidLoad() {
      super.viewDidLoad()
  
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ActionViewController.done))
    
    if let inputItem = extensionContext!.inputItems.first as? NSExtensionItem {
      if let itemProvider = inputItem.attachments?.first as? NSItemProvider {
        itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String, options: nil) { [unowned self] (dict, error) in
          let itemDictionary = dict as! NSDictionary
          let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary
          
          self.url = javaScriptValues["URL"] as! String
          
          DispatchQueue.main.async {
            self.title = "Ham-it"
          }
        }
      }
    }
  }
  
  @IBOutlet weak var messageLabel: UILabel!
  @IBAction func addGif(_ sender: UIButton) {
    var imgurId = ""
    if (self.url.range(of: "imgur", options: .regularExpression) != nil) {
      if let match = self.url.range(of: "(\\w*)$", options: .regularExpression) {
        imgurId = self.url.substring(with: match)
      }
    }
    
    guard imgurId.characters.count > 1 else {
     self.messageLabel.text = "Wasn't able to parse the imgur id - #failed"
      return
    }
    
    let gifService = GifService()
    gifService.addGif(imgurId, completion: { [weak self] success in
      if success {
        self?.messageLabel.text = "Success"
      }
    })
    
  }

  @IBAction func done() {
      // Return any edited content to the host app.
      // This template doesn't do anything, so we just echo the passed in items.
      self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
  }

}
